Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941752F27
	for <nvdimm@lists.linux.dev>; Tue,  1 Feb 2022 22:24:58 +0000 (UTC)
Received: by mail-pg1-f174.google.com with SMTP id h23so16648371pgk.11
        for <nvdimm@lists.linux.dev>; Tue, 01 Feb 2022 14:24:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u2EiycHzHs1b2F0/iUOQ5xWejurFd89dED1f6mm35uU=;
        b=Y0sGYPzdHJHWs/JbjpkQqTUt5gZlw5M1EoAw2VCHVnpy4C8y8DiEYyXlYCBQdlxmSu
         adcAvLvEfHcEoTBXYXNvloavzagYMZp8M6InndBAYrNCgogFr2RlS4bq9bUYqwcQMAW8
         McrP08GZRkUZm0ZyBltFlqcHvImGOojGi8MBpz4622WPOyXvkN8JM3bZ0q9O+QBx9dZW
         Wf3aBKhd2/E9HgPnIuFon6fdVkHIpctaeUgWs2UF/N55V+Ot0GqKd8EvHILBGPiNaqlI
         a1ccCsnmFN2MTcFf5QsNTrave0mukNCYHR7wvvoqLrNa1+4xbkjWYlhQYukUAt+A3r10
         8W7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u2EiycHzHs1b2F0/iUOQ5xWejurFd89dED1f6mm35uU=;
        b=ByTSgMbA9L1z9lRMgNY0MwS4AmsZSnBIimrCHIrQPJoj/6Z8PM4a6c9WcC/BY1lL7J
         78kM82thdJh/oPAFxzkUYgPz47xvjQEVHHrMJKdIroVo5b6fAgewyterp3gU+ySu8/DE
         Q3JdiZOUruvk2Fw4poaonJYRhDTe/o3EYKvDNFQBLk7vPdBlJeykyo4Y5IydJyoiHe62
         nrfS4mlzxG1kTkfItJKdcV/bKjCWGIIqoruHWIJnjHNm+g7VwAnICXg2i53qzGakLdUL
         2ATw+H04F6p0qq3I2Bbxtpivb00JhxszGN1AhyTN8wgq6xQJNfYttJi4gu32t7sbMXll
         H+4A==
X-Gm-Message-State: AOAM532fGZfmFIuTq9PiR/pwE+QtH1Bem6Q63zjgDVpUFGOWcBqjEU6R
	JjbBtSJsxNN9d6vVYHKd+VferuN2385RJB9PbYT6yQ==
X-Google-Smtp-Source: ABdhPJwTDsUmAvr06z8oPX9E1R3lrXOzRtesNHE2KuqBx7W0JHyBi+Kv07nLiKYh4+e2w4FdOlqvPRpyYYDAbwHQN1g=
X-Received: by 2002:a63:550f:: with SMTP id j15mr22088163pgb.40.1643754298047;
 Tue, 01 Feb 2022 14:24:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
 <164298426273.3018233.9302136088649279124.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20220131181924.00006c57@Huawei.com> <20220201152410.36jvdmmpcqi3lhdw@intel.com>
 <CAPcyv4iyRKfviJNtHP=wsqRtppDb+BrmhNeum+ZcyBAJ5VSPtA@mail.gmail.com>
 <20220201221114.25ivh5ubptd7kauk@intel.com> <CAPcyv4hYSm+q1RYnrdNvr_dXsU-OZ-v94RRvNGtr5-wtHc97=w@mail.gmail.com>
 <20220201222042.hv2xipmuous7s7qh@intel.com>
In-Reply-To: <20220201222042.hv2xipmuous7s7qh@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 1 Feb 2022 14:24:51 -0800
Message-ID: <CAPcyv4hhOa8hRdy3R8oiuw9Whfke-s67KfvcazP4VFuhuXCtsQ@mail.gmail.com>
Subject: Re: [PATCH v3 27/40] cxl/pci: Cache device DVSEC offset
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>, linux-cxl@vger.kernel.org, 
	Linux PCI <linux-pci@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Tue, Feb 1, 2022 at 2:20 PM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> On 22-02-01 14:15:22, Dan Williams wrote:
> > On Tue, Feb 1, 2022 at 2:11 PM Ben Widawsky <ben.widawsky@intel.com> wrote:
> > >
> > > On 22-02-01 13:41:50, Dan Williams wrote:
> > > > On Tue, Feb 1, 2022 at 7:24 AM Ben Widawsky <ben.widawsky@intel.com> wrote:
> > > > >
> > > > > On 22-01-31 18:19:24, Jonathan Cameron wrote:
> > > > > > On Sun, 23 Jan 2022 16:31:02 -0800
> > > > > > Dan Williams <dan.j.williams@intel.com> wrote:
> > > > > >
> > > > > > > From: Ben Widawsky <ben.widawsky@intel.com>
> > > > > > >
> > > > > > > The PCIe device DVSEC, defined in the CXL 2.0 spec, 8.1.3 is required to
> > > > > > > be implemented by CXL 2.0 endpoint devices. Since the information
> > > > > > > contained within this DVSEC will be critically important, it makes sense
> > > > > > > to find the value early, and error out if it cannot be found.
> > > > > > >
> > > > > > > Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
> > > > > > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > > > > > Guess the logic makes sense about checking this early though my cynical
> > > > > > mind says, that if someone is putting in devices that claim to be
> > > > > > CXL ones and this isn't there it is there own problem if they
> > > > > > kernel wastes effort bringing the driver up only to find later
> > > > > > it can't finish doing so...
> > > > >
> > > > > I don't remember if Dan and I discussed actually failing to bind this early if
> > > > > the DVSEC isn't there.
> > > >
> > > > On second look, the error message does not make sense because there is
> > > > "no functionality" not "limited functionality" as a result of this
> > > > failure because the cxl_pci driver just gives up. This failure should
> > > > be limited to cxl_mem, not cxl_pci as there might still be value in
> > > > accessing the mailbox on this device.
> > > >
> > > > > I think the concern is less about wasted effort and more
> > > > > about the inability to determine if the device is actively decoding something
> > > > > and then having the kernel driver tear that out when it takes over the decoder
> > > > > resources. This was specifically targeted toward the DVSEC range registers
> > > > > (obviously things would fail later if we couldn't find the MMIO).
> > > >
> > > > If there is no CXL DVSEC then cxl_mem should fail, that's it.
> > > >
> > >
> > > If there is no CXL DVSEC we have no way to find the device's MMIO. You need the
> > > register locator dvsec. Not sure how you intend to do anything with the device
> > > at that point, but if you see something I don't, then by all means, change it.
> >
> > I see:
> >
> > pci_find_dvsec_capability(pdev, PCI_DVSEC_VENDOR_ID_CXL, CXL_DVSEC_PCIE_DEVICE);
> >
> > ...and:
> >
> > pci_find_dvsec_capability(pdev, PCI_DVSEC_VENDOR_ID_CXL, CXL_DVSEC_REG_LOCATOR);
> >
> > ...aren't they independent?
>
> My mistake. I was thinking of a different patch, "cxl/pci: Retrieve CXL DVSEC
> memory info". You're correct, they are independent (both mandatory for type 3
> devices).
>
> However, Jonathan was the one who originally suggested it. I had it as a warn
> originally.
> https://lore.kernel.org/linux-cxl/20211122223430.gvkwj3yeckriffes@intel.com/

At least to the concern of "nothing" working without the base CXL
DVSEC the cxl_mem driver failing to attach catches that case.
Otherwise a device that only implements the mailbox seems not outside
the realm of possibility. Jonathan?
