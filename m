Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com
 [67.231.153.30])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8AA4521C9126D
 for <linux-nvdimm@lists.01.org>; Tue, 25 Jul 2017 08:10:52 -0700 (PDT)
Subject: Re: Moving ndctl development into the kernel tree?
References: <CAPcyv4hCymUQ--+h=TNKgfDfk7Zp22kr7HDzXuaUsSE92GYcPA@mail.gmail.com>
 <20170721225815.i6467grjen32x4kq@gmail.com>
 <CAPcyv4iNuUpVE=n7sY+OD3eRxeQeskNuU6QC2j=xxFB3bpWiSA@mail.gmail.com>
 <CAPcyv4iTH45DsNmqd736zscojzHf=QoXU9SDxgosmmb+eshkRQ@mail.gmail.com>
 <CAPcyv4iU5XSa4REQOpw_c4Wk=_76m2KgC9zdqkncRkGvLMsaQQ@mail.gmail.com>
From: Chris Mason <clm@fb.com>
Message-ID: <f782b3e1-5b3b-805f-65fd-16b84c5f50a3@fb.com>
Date: Tue, 25 Jul 2017 11:12:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAPcyv4iU5XSa4REQOpw_c4Wk=_76m2KgC9zdqkncRkGvLMsaQQ@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>, Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jiri Olsa <jolsa@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@kernel.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On 07/22/2017 02:49 PM, Dan Williams wrote:
> On Fri, Jul 21, 2017 at 7:52 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>> [ adding Chris ]
>>
>> On Fri, Jul 21, 2017 at 4:44 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>>> On Fri, Jul 21, 2017 at 3:58 PM, Ingo Molnar <mingo@kernel.org> wrote:
>>>>
>>>> * Dan Williams <dan.j.williams@intel.com> wrote:
>>>>
>>>>> [...]
>>>>>
>>>>> * Like perf, ndctl borrows the sub-command architecture and option
>>>>> parsing from git. So, this code could be refactored into something
>>>>> shared / generic, i.e. the bits in tools/perf/util/.
>>>>
>>>> Just as a side note, stacktool (tools/stacktool/) is using the Git sub-command and
>>>> options parsing code as well, and it's already sharing it with perf, via the
>>>> tools/lib/subcmd/ library.
>>>>
>>>> ndctl could use that as well.
>>>
>>> Ah, nice, that refactoring happened about a year after ndctl was born.
>>> Which brings up the next question about what to do with the git
>>> history, but I'd want to know if ndctl is even welcome upstream before
>>> digging any deeper.
>>
>> I suspect this would be similar to what Chris did to merge btrfs while
>> retaining the standalone history. Chris, any pointers on what worked
>> well and what if anything you would do differently? I.e. I'm looking
>> to use git filter-branch to rewrite ndctl history as if if had always
>> been in tools/ndctl in the kernel tree. I found this old thread
>> https://lkml.org/lkml/2008/10/30/523 and it seems to also recommend
>> using an older kernel as the branch base.
> 
> So it wasn't as painful as I thought it would be, I just used the
> script Linus recommended in that thread. Here is what I came up with
> merging the last ndctl release on top of v4.9, and then applying the
> pending development patches re-filtered to tools/ndctl:
> 
>      https://git.kernel.org/pub/scm/linux/kernel/git/djbw/nvdimm.git/log/?h=for-4.14/ndctl
> 
> ...the next thing would be to rework the versioning to use the kernel
> version and switch to using tools/lib/subcmd/.
> 

I'd like to say I figured it all out back then, but the truth is that 
Linus held my hand the whole way.  My memory of it is that his script 
worked really well, I just ran that and verified the results.

-chris
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
