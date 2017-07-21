Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x22f.google.com (mail-yw0-x22f.google.com
 [IPv6:2607:f8b0:4002:c05::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 359D52095D9CA
 for <linux-nvdimm@lists.01.org>; Fri, 21 Jul 2017 16:42:55 -0700 (PDT)
Received: by mail-yw0-x22f.google.com with SMTP id v128so3740317ywb.1
 for <linux-nvdimm@lists.01.org>; Fri, 21 Jul 2017 16:44:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170721225815.i6467grjen32x4kq@gmail.com>
References: <CAPcyv4hCymUQ--+h=TNKgfDfk7Zp22kr7HDzXuaUsSE92GYcPA@mail.gmail.com>
 <20170721225815.i6467grjen32x4kq@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 21 Jul 2017 16:44:51 -0700
Message-ID: <CAPcyv4iNuUpVE=n7sY+OD3eRxeQeskNuU6QC2j=xxFB3bpWiSA@mail.gmail.com>
Subject: Re: Moving ndctl development into the kernel tree?
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
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jiri Olsa <jolsa@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@kernel.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jul 21, 2017 at 3:58 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Dan Williams <dan.j.williams@intel.com> wrote:
>
>> [...]
>>
>> * Like perf, ndctl borrows the sub-command architecture and option
>> parsing from git. So, this code could be refactored into something
>> shared / generic, i.e. the bits in tools/perf/util/.
>
> Just as a side note, stacktool (tools/stacktool/) is using the Git sub-command and
> options parsing code as well, and it's already sharing it with perf, via the
> tools/lib/subcmd/ library.
>
> ndctl could use that as well.

Ah, nice, that refactoring happened about a year after ndctl was born.
Which brings up the next question about what to do with the git
history, but I'd want to know if ndctl is even welcome upstream before
digging any deeper.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
