Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8EA50211CC3BA
 for <linux-nvdimm@lists.01.org>; Wed, 20 Feb 2019 11:40:21 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id n8so42211631otl.6
 for <linux-nvdimm@lists.01.org>; Wed, 20 Feb 2019 11:40:21 -0800 (PST)
MIME-Version: 1.0
References: <20181026003729.8420-1-vishal.l.verma@intel.com>
 <x49lg2a2sn0.fsf@segfault.boston.devel.redhat.com>
 <20190220191852.GF3447@zn.tnic>
 <x49d0nm2rd6.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49d0nm2rd6.fsf@segfault.boston.devel.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 20 Feb 2019 11:40:10 -0800
Message-ID: <CAPcyv4hNq8TPVkrNwqZJHyfSg+JUHG6taS5pz0r6+xAa29NTag@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] nfit, mce: only handle uncorrectable machine checks
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>, linux-edac@vger.kernel.org, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Feb 20, 2019 at 11:26 AM Jeff Moyer <jmoyer@redhat.com> wrote:
>
> Borislav Petkov <bp@alien8.de> writes:
>
> > Drop stable@
> >
> > On Wed, Feb 20, 2019 at 01:59:15PM -0500, Jeff Moyer wrote:
> >> Sorry for necroposting.  I thought the point of the CEC was to make sure
> >> that the other registered decoders only ever saw uncorrected errors.
> >
> > Ha, good point! You mean drivers/ras/cec.c, right?
>
> Yes.
>
> > If so, then I don't think we've ever talked about connecting CEC with
> > NVDIMM and whether that would make sense. Lemme add Dan.
>
> I don't think there's a difference between MCEs for NVDIMMs and normal
> DRAM.  I'll let Dan confirm or deny that.

There is a difference. NVDIMMs have local tracking of discovered
poison, methods to scan for latent poison, and methods to clear. A CEC
connection, iiuc, would seem an awkward fit. Awkward because what CEC
enables is meant to be implemented natively in the hardware, and CEC
seems to have no concept of the fact that errors can be repaired.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
