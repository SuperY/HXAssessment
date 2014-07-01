var _RTEFunc={
    "isTablet":function(){
        //判断处理是否平板
        console.log('判断是否是平板');
        return true;
    },
    "isEnterExam":function(){
        //处理enterExam
        console.log('判断是否进入考试');
        return true;
    },
    "SaveItem":function(id,code,answer){
        console.log('保存答案');
        console.log(id+"-"+code+"-"+answer);
        bridge.callHandler('testObjcCallback', {'foo': 'bar'}, function(response) {
                           log('JS got response', response)
                           })
    },
    "setTop":function(top){
        console.log('设置top');
        console.log(top);
    },
    "getUserAnswer":function(qid){
        console.log('获取用户答案');
        console.log(qid);
    },
    "getQuestionAnswer":function(qid){
        console.log('获取问题答案');
        console.log(qid);
    },
    "isAllowSeeAnswer":function(){
        console.log('允许看问题');
        return true;
    }
};



(function($){


    window.__RTE=null;
	var recNum=0;
	var top=0;
	function FindApi(p){
		recNum++;
		if(!!p.__ExamIns){
			return p.__ExamIns;
		}else if(recNum<6){
			if(!!p.parent){
				return FindApi(p.parent);
			}
		}
		return null;
	};
	window.__Exam_PaperInit=function(){

		//window.__RTE =FindApi(window);
		var exam=_RTEFunc;//window.__RTE;
		var question = $('.ui-question');
		if( question.length>0 && !question.hasClass('ui-question-4') ){
			if(!exam.isTablet()){
				setImageClickable();
				$('.ui-question > .ui-question-title > .ui-question-content-wrapper > p > span').removeAttr("style");
			}
			if(exam.isEnterExam()){
				rejectSaveAnswerEvent( question );
				initMobileExamAnswer( question );
			}else{
				$('.ui-question-textarea', question).attr('disabled','disabled');
				initMobileResultAnswer( question );
			}


		}
	};
	function rejectSaveAnswerEvent( question ){
        var exam=_RTEFunc;//window.__RTE;
		var _begin=new Date(), _x=0, _y=0;
		//点击选项，也可以选中答案
		$('.ui-question-options>li', question).on('click',function(e){
				e.preventDefault();
				var t=$(this),parent=t.parent().parent(),answer='',isChanged=false;
				if(!!parent){
					if(parent.hasClass('ui-question-1')){
						if(!t.hasClass('ui-option-selected')){
							$('.ui-question-options>li.ui-option-selected', parent).removeClass('ui-option-selected');
							t.addClass('ui-option-selected');
							answer=t.attr('code');
							isChanged=true;
						}
					}else if(parent.hasClass('ui-question-2')){
						isChanged=true;
						t.toggleClass('ui-option-selected');
						$('.ui-question-options>li.ui-option-selected',parent).each(function(){
							answer=answer+$(this).attr('code');
						});
					}
					if(isChanged){exam.SaveItem(parent.prop('id').substring(2), parent.attr('code').substring(4),answer);}
				}
		});
		$('.ui-question-textarea', question).on('focus',function(){
			if(top<1){
				var paper = window.document;
				top = $('.ui-question-textarea',question).offset().top;
				$(".ui-paper-wrapper").css({ height: $(".ui-paper-wrapper").height() + top });
				$(document).scrollTop(top);
				exam.setTop(top);
			}
		});

		$('.ui-question-textarea', question).on('change',function(){
			var parent=$(this).parent();
			if(!!parent){
				var answer=$(this).val();
				exam.SaveItem(parent.prop('id').substring(2), parent.attr('code').substring(4),answer);
			}
		});
	};

	window.__OnKeybordHidden = function(){
		$(".ui-paper-wrapper").css({ height: $(".ui-paper-wrapper").height() - top });
		$(document).scrollTop(0);
		top=0;
	}

	window.lose_focus = function(){
		var txtObj =$('.ui-question-textarea');
		if(!!txtObj){
			txtObj.blur();}
	};

	function initMobileResultAnswer( q ){
        var exam=_RTEFunc;//window.__RTE;
		q.addClass('ui-result');
		var qid= q.attr('id').substring(2);
		var uajson=null, qajson=null;
		var ua = exam.getUserAnswer(qid);
		var qa = exam.getQuestionAnswer(qid);
		if(!q.hasClass('ui-question-4')){  //不是复合题
			if(ua && ua!='null' ){
				initUserAnswer(q, ua ,false);
			}
			if(qa && qa!='null'){
				var qajson = eval('('+qa+')');
				showUserAnswerRightStatus(q, qajson);
				if( exam.isAllowSeeAnswer() ){
					showQuestionAnswerAndHint(q, qajson); //显示正确答案和提示
				}
			}
		}
	};
	function initMobileExamAnswer( q ) {
        var exam=_RTEFunc;//window.__RTE;
		var qid= q.attr('id').substring(2);
		var ua = exam.getUserAnswer(qid);
		if(ua && ua!='null'){
			initUserAnswer(q, ua ,true);
		}
	};
	function initUserAnswer(question, answer, isEnterExam){
		if(question.hasClass('ui-question-1')){ //单选题
			$('.ui-question-options>li[code="'+answer+'"]',question).addClass('ui-option-selected');
		}else if(question.hasClass('ui-question-2')){  //多选题
			$('.ui-question-options>li',question).each(function(){
				var t=$(this);
				if(answer.indexOf(t.attr('code'))!=-1){
					t.addClass('ui-option-selected');
				}
			});
		}else{   //问答题及其他
			if(isEnterExam){
				$('.ui-question-textarea',question).val(answer);
			}else{
				$('.ui-question-textarea',question).after('<div class="ui-textarea-result" height="min-height"><p>'+answer+'</p></div>');
				$('.ui-question-textarea',question).hide();
			}
		}
	};
	function showQuestionAnswerAndHint(question, answer){
		if( question.hasClass('ui-question-1') || question.hasClass('ui-question-2') ){
			for(var j=0; j<answer.answer.length; j++){
				var c = answer.answer.charAt(j);
				$('.ui-question-options>li[code='+c+']', question).addClass('ui-correct-answer');
			}
		}else if( !question.hasClass('ui-question-4') ){  //非复合题
			question.append('<div class="ui-question-answer">答案：'+answer.answer+'</div>');
		}
		if(!!answer.hint){
			question.append('<div class="ui-question-hint">'+answer.hint+'</div>');
		}
		reTranslate(); //重新显示公式符号
	};
	function appendAnswerEmptyStatus( qt ){
		qt.append('<span class="ui-question-answer-error">您没有作答</span>');
	};
	function appendAnswerRightStatus( qt ){
		qt.append('<span class="ui-question-answer-right">您答对了</span>');
	};
	function appendAnswerErrorStatus( qt ){
		qt.append('<span class="ui-question-answer-error">您答错了</span>');
	};
	function showUserAnswerRightStatus(question, answer){
		var qt=$(".ui-question-title",question);
		if(answer.type==1){/*单选题*/
			var sel=$('.ui-question-options>li.ui-option-selected',question);
			if( !sel || sel.length==0 ){
				appendAnswerEmptyStatus( qt );
			}
			else if( sel.attr("code")==answer.answer){
				appendAnswerRightStatus( qt );
			}else{
				appendAnswerErrorStatus( qt );
			}
		}
		else if( answer.type==2 ){
			var temp = answer.answer;
			var sel=$('.ui-question-options>li.ui-option-selected',question);
			if( !sel || sel.length==0 ){
				appendAnswerEmptyStatus( qt );
			}else{
				sel.each(function(){
					var c = $(this).attr('code');
					if(temp.indexOf(c)<0){
						temp += c;
						return;
					}else{
						temp=temp.replace(c,'');
					}
				});
				if(temp.length==0){
					appendAnswerRightStatus( qt );
				}else{
					appendAnswerErrorStatus( qt );
				}
			}
		}
	};

	function setImageClickable(){
		//增加图片点击效果
		var paper=window.document;
		var bimg=$('<div style="position:absolute;z-index:1001;display:none"></div>');
		var modal=$('<div style="position:absolute;top:0;left:0;width:100%;z-index:1000;display:none;background:#dddddd;opacity: 0.8;"></div>');
		$('.ui-paper-wrapper',paper).append(bimg).append(modal);
		bimg.click(function(){
			$(this).hide();
			modal.hide();
		});
		modal.click(function(){
			$(this).hide();
			bimg.hide();
		})
		$('.ui-question-title img,.ui-question-answer img,.ui-question-hint img', paper).unbind('click');
		$('.ui-question-title img,.ui-question-answer img,.ui-question-hint img', paper).click(function(){
			if( bimg.is(':hidden')){
				var img = $(this);
				var iw=img.width(), ih=img.height();
				var ww=$(window).width(), wh=$(window).height();
				if(iw*1.0/ww>ih*1.0/wh){
					iw=ww;
					ih=ih*ww/iw;
				}else{
					ih=wh;
					iw=iw*wh/ih;
				}
				bimg.empty();
				bimg.append('<img src="'+img.attr('src')+'" width="'+iw+'" height="'+ih+'" />');
				bimg.css('left', (ww-iw)/2);
				bimg.css('top', (wh-ih)/2);
				bimg.show();
				modal.height($(window).height());
				modal.show();
			}
		});
	};
})(jQuery);
