Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x22c.google.com (mail-yw0-x22c.google.com
 [IPv6:2607:f8b0:4002:c05::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0E86821D1B286
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jul 2017 09:01:07 -0700 (PDT)
Received: by mail-yw0-x22c.google.com with SMTP id l82so32352702ywc.2
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jul 2017 09:03:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170726112935.a4ztsb6yke7bhsvo@gmail.com>
References: <150102217021.2258.1380624380896006.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150102218643.2258.15362632812220627446.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170725235512.GC23846@kernel.org>
 <CAPcyv4g1V=1E-cOzHabZswwVGmJGQUNSYxnSyOtwxo79eRYyNw@mail.gmail.com>
 <20170726112935.a4ztsb6yke7bhsvo@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 26 Jul 2017 09:03:08 -0700
Message-ID: <CAPcyv4gjMWz814BSdmmM=MEJAuJ3bkJhM9pcdgVK+XW0hMJ9ng@mail.gmail.com>
Subject: Re: [PATCH 3/4] ndctl: switch to tools/include/linux/{kernel, list,
 bitmap}.h
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Peter Zijlstra <peterz@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Ingo Molnar <mingo@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 26, 2017 at 4:29 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Dan Williams <dan.j.williams@intel.com> wrote:
>
>> On Tue, Jul 25, 2017 at 4:55 PM, Arnaldo Carvalho de Melo
>> <acme@kernel.org> wrote:
>> > Em Tue, Jul 25, 2017 at 03:36:26PM -0700, Dan Williams escreveu:
>> >> Replace the ccan implementation of list primitives, bitmap helpers and
>> >> small utility macros with the common definitions available in
>> >> tool/include/linux.
>> >
>> > You should first add what you need in separate patches, paving the way
>> > to then use it, and some stuff are already there, see below:
>>
>> Ok, I'll break out those changes separately.
>
> BTW., another general observation I have is that ndctl uses autotools - while perf
> uses its own build system, some of which is abstracted out into tools/build/ and
> reused by other tooling projects as well.
>
> I despise autotools with a passion, it's slow, bloated, and encourages all sorts
> of bad API/ABI practices that plagues many OSS projects. I know that Linus
> explicitly did a Makefile based build system for Git for (I think) similar
> reasons.
>
> It might be a good idea to not let autotools into the kernel tooling tree, not
> because ndctl's use of autotools is bad in any fashion (it appears to be a fairly
> straightforward use), but to generally encourage good API/ABI practices in our
> tooling space, and to encourage enhancements to the tools/build/ infrastructure.

That's a fair point. Regardless, autotools will be in the git history,
but if you'd like to see the final merge product eliminate its use, I
can't really argue otherwise. I was originally not concerned because
tools/usb/usbip/ was an existing in tree autotools user. In any event
if you want the autotools removal to be done out-of-tree I'll need to
put this effort on the back burner until 4.15.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
