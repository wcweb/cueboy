package us.wcweb.Cueboy.model.pagination {
	/**
	 * @author Administrator
	 */
	public class PaginationGenerator {
		public var oldpage:Number = -1;
		private static var _instance : PaginationGenerator;

		public static function getInstance() : PaginationGenerator {
			if (PaginationGenerator._instance == null) {
				PaginationGenerator._instance = new PaginationGenerator();
			}
			return PaginationGenerator._instance;
		}

		public function build(defaultPage : Pagination) : Pagination {
			if ( defaultPage.total <= 0 ) throw Error("total表示为分页的总数，因此只能为正整数。");
			if ( defaultPage.page <= 0 ) throw Error("page表示为当前页，因此只能为正整数。");
			if ( defaultPage.pagesize <= 0 ) throw Error("pagesize表示为每页的内容数，因此只能是正整数。");
			if ( defaultPage.offset < 0 ) throw Error("offset表示为偏移量，因此只能为正整数");
			if ( defaultPage.length <= 0 ) throw Error("length表示为步长，因此只能为正整数");
			var total : int = defaultPage.total;
			var page : int = defaultPage.page;
			var pagesize : int = defaultPage.pagesize;
			var offset : int = defaultPage.offset;
			var length : int = defaultPage.length;
			var lastpage : int = Math.ceil(total / pagesize);

			if ( page > lastpage ) throw Error("当前页数（page）不能超过分页总数（lastpage）。");

			var loopcount : int = Math.ceil(lastpage / pagesize); // what it mean by?

			page = page > lastpage ? 1 : page;

			var previous : int = page - 1;
			var next : int = page + 1;

			// 是否显示前一页/后一页
			var isPrevious : Boolean, isNext : Boolean;
			isNext = next - 1 < lastpage ? true : false;
			isPrevious = previous > 0 ? true : false;

			var begin : int,end : int,step : int;
			// 4 5 (6) 7 8 
			step =  lastpage > length ? length: lastpage;
			
			if(offset > 0 ){
				begin = page <= offset ? 1 : page-offset;
			}
			else if ( offset == 0 && page == 1 ) {
				begin  = 1;
			}
			else if ( page != 1 && oldpage < page ) {
				begin  = page     < pagesize        ? 1            : page;
			}
			else if ( page != 1 && oldpage >= page ) {
				begin  = page     < pagesize        ? 1            : page - step + 1;
			}
			//计算结束
			end        = begin    +  step;
			//如果end比lastpage大的话，赋值为lastpage
			end        = end      >= lastpage       ? lastpage + 1 : end;

			if ( end - begin + 1 != step ) {
				end = begin + step;
			}
			if ( begin + step - 1 > lastpage ) {
				begin = lastpage - step + 1;
				end   = lastpage + 1;
			}
			
			//前滚、后滚
			//是否显示>> and <<
			var isForward : Boolean, isBack : Boolean;
			isForward = lastpage - end >= 1         ? true         : false;
			isBack    = begin          >  1         ? true         : false;

			//前进/后退到第几页
			var forward : int, back : int;
			back      = begin - 1      <= 0         ? 1            : begin - 1;
			forward   = end;

			//当前的page数组
			var i : int;
			var arr : Array = [];
			for ( i = begin; i < end; i++ ) {
				var tmp :PaginationPage  = new PaginationPage();
				tmp.pageNum = i;
				if ( i == page ) tmp.currentPage = i;
				else             tmp.currentPage = -1;
				arr.push( tmp );
			}

			//总长度
			var totalarr : Array = [];
			for ( i = 1; i <= lastpage; i++ ) {
				totalarr.push( i );
			}


			var pv : Pagination = new Pagination();
			pv.total = defaultPage.total;
			// 总数
			pv.total = total;
			// 当前页
			pv.page = page;
			// 每页的内容数
			pv.pagesize = pagesize;
			// 最后一页
			pv.lastpage = lastpage;
			// 共计多少分页
			pv.loopcount = loopcount;
			// 前一页
			pv.previous = previous;
			// 后一页
			pv.next = next;
			// 是否显示前一页
			pv.isPrevious = isPrevious;
			// 是否显示后一页
			pv.isNext = isNext;
			// 开始
			pv.begin = begin;
			// 结束
			pv.end = end;
			// 步长
			pv.step = step;
			// 前滚
			pv.isForward = isForward;
			// 后滚
			pv.isBack = isBack;
			// 前进的页数
			pv.forward = forward;
			// 后退的页数
			pv.back = back;
			// 偏移量
			pv.offset = offset;
			// begin -> end 时的步长
			pv.length = length;
			// page list
			pv.pagelist.source = arr;
			// total page list
			pv.totallist.source = totalarr;

			return pv;
		}
	}
}
