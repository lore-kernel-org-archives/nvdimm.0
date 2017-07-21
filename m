Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm0-x22c.google.com (mail-wm0-x22c.google.com
 [IPv6:2a00:1450:400c:c09::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 432942095D9D9
 for <linux-nvdimm@lists.01.org>; Fri, 21 Jul 2017 15:56:22 -0700 (PDT)
Received: by mail-wm0-x22c.google.com with SMTP id e131so24879985wme.0
 for <linux-nvdimm@lists.01.org>; Fri, 21 Jul 2017 15:58:19 -0700 (PDT)
Date: Sat, 22 Jul 2017 00:58:15 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: Moving ndctl development into the kernel tree?
Message-ID: <20170721225815.i6467grjen32x4kq@gmail.com>
References: <CAPcyv4hCymUQ--+h=TNKgfDfk7Zp22kr7HDzXuaUsSE92GYcPA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hCymUQ--+h=TNKgfDfk7Zp22kr7HDzXuaUsSE92GYcPA@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jiri Olsa <jolsa@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@kernel.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>


* Dan Williams <dan.j.williams@intel.com> wrote:

> [...]
> 
> * Like perf, ndctl borrows the sub-command architecture and option
> parsing from git. So, this code could be refactored into something
> shared / generic, i.e. the bits in tools/perf/util/.

Just as a side note, stacktool (tools/stacktool/) is using the Git sub-command and 
options parsing code as well, and it's already sharing it with perf, via the 
tools/lib/subcmd/ library.

ndctl could use that as well.

Thanks,

	Ingo
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
