Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 43A71211CBCFE
 for <linux-nvdimm@lists.01.org>; Wed, 20 Feb 2019 11:26:47 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v3 1/2] nfit, mce: only handle uncorrectable machine checks
References: <20181026003729.8420-1-vishal.l.verma@intel.com>
 <x49lg2a2sn0.fsf@segfault.boston.devel.redhat.com>
 <20190220191852.GF3447@zn.tnic>
Date: Wed, 20 Feb 2019 14:26:45 -0500
In-Reply-To: <20190220191852.GF3447@zn.tnic> (Borislav Petkov's message of
 "Wed, 20 Feb 2019 20:18:52 +0100")
Message-ID: <x49d0nm2rd6.fsf@segfault.boston.devel.redhat.com>
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
To: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@intel.com>, linux-edac@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Borislav Petkov <bp@alien8.de> writes:

> Drop stable@
>
> On Wed, Feb 20, 2019 at 01:59:15PM -0500, Jeff Moyer wrote:
>> Sorry for necroposting.  I thought the point of the CEC was to make sure
>> that the other registered decoders only ever saw uncorrected errors.
>
> Ha, good point! You mean drivers/ras/cec.c, right?

Yes.

> If so, then I don't think we've ever talked about connecting CEC with
> NVDIMM and whether that would make sense. Lemme add Dan.

I don't think there's a difference between MCEs for NVDIMMs and normal
DRAM.  I'll let Dan confirm or deny that.

>> How do we end up getting called with a correctable error?
>
> Good question. We shouldn't.
>
> So we need to figure out here how exactly should those things interact
> and whether NFIT should get all errors reported or it should put all the
> correctable errors through the decay thing, see the comment at the top
> of drivers/ras/cec.c
>
> Thx for pointing that out Jeff.

Sure, thanks for the quick reply, Boris!  Also, thanks for your detailed
commit messages.  They really help with understanding the code changes.

Cheers,
Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
