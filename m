Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 853E920214B3A
 for <linux-nvdimm@lists.01.org>; Mon, 19 Aug 2019 07:33:50 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 2/3] libnvdimm/security: Tighten scope of nvdimm->busy vs
 security operations
References: <156583201347.2815870.4687949334637966672.stgit@dwillia2-desk3.amr.corp.intel.com>
 <156583202386.2815870.16611751329252858110.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x49zhk8bzuh.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4iPBO9atdr_LdHNt=tCgjh-j_HyKXaCdUkWxb_J7OCcxg@mail.gmail.com>
Date: Mon, 19 Aug 2019 10:32:22 -0400
In-Reply-To: <CAPcyv4iPBO9atdr_LdHNt=tCgjh-j_HyKXaCdUkWxb_J7OCcxg@mail.gmail.com>
 (Dan Williams's message of "Fri, 16 Aug 2019 14:02:19 -0700")
Message-ID: <x49d0h1usy1.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

> On Fri, Aug 16, 2019 at 1:49 PM Jeff Moyer <jmoyer@redhat.com> wrote:
>>
>> Dan Williams <dan.j.williams@intel.com> writes:
>>
>> > The blanket blocking of all security operations while the DIMM is in
>> > active use in a region is too restrictive. The only security operations
>> > that need to be aware of the ->busy state are those that mutate the
>> > state of data, i.e. erase and overwrite.
>> >
>> > Refactor the ->busy checks to be applied at the entry common entry point
>> > in __security_store() rather than each of the helper routines.
>>
>> I'm not sure this buys you much.  Did you test this on actual hardware
>> to make sure your assumptions are correct?  I guess the worst case is we
>> get an "invalid security state" error back from the firmware....
>>
>> Still, what's the motivation for this?
>
> The motivation was when I went to test setting the frozen state and
> found that it complained about the DIMM being active. There's nothing
> wrong with freezing security while the DIMM is mapped. ...but then I
> somehow managed to write this generalized commit message that left out
> the explicit failure I was worried about. Yes, moved too fast, but the
> motivation is "allow freeze while active" and centralize the ->busy
> check so it's just one function to review that common constraint.

OK, thanks for the info.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
