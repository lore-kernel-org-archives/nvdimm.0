Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785F42C80
	for <nvdimm@lists.linux.dev>; Tue,  1 Feb 2022 00:00:15 +0000 (UTC)
Received: by mail-pg1-f171.google.com with SMTP id g2so13714508pgo.9
        for <nvdimm@lists.linux.dev>; Mon, 31 Jan 2022 16:00:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G2w+PybZGj1Pt9zwKncrlYIefOTBGfgydX9Jj0viB1o=;
        b=wmUftE29XD1cDjU2mgt+TtdTRcVStkpoChebeK06YjxXDFn3MLM97GInA/Gu6+SXYS
         DhG8N7qdCycIXw3pXmtttGD6SZm85zuJ+aN1ueV6yTp+qZJBcFCodkuIPa+8rN6xPVpB
         dPw7rP6k7+X6a5IsGq+5ssrW1VpAHMdmz+PjiCCFaoc5ME42lBpONkSbFVxyYruu94hT
         j7RO5t1DKQ1G8fQhhgWU26Pg/xB584tAzvTNpQG5Zz4Tz1zvd7dHJMaeQvdFrm/j46uw
         mMPe7o/aUCvpdXNIhJnFAANBBS64dYM+b1TnKfkCVLMeFgMEcP78hDZHkk1c1MNj/Wv1
         h0Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G2w+PybZGj1Pt9zwKncrlYIefOTBGfgydX9Jj0viB1o=;
        b=4a/wBt6/uscMx6FFVUQqLMNVADF1EXpte1aELlR6e5lHRzwY2lREFKV4F5LFDMSNo8
         nQhu0gIFAdDA/wN4ZvWSPlwxKruKrFwOZ8C2aJtL3jSXn/ec9dJBfuguJITBznNKVRhc
         6sO/gGmJf0VrzmSfuQEsBu5MY2TelSgaec5CCMethbY/m9/DLNcvCp5U7hHUlAk5FEGX
         qfwMHKNX+CgQwO0mAu0f+GjzMoQqDTnRkFnwr5EPCE2FNStzKpclGjoHFpSgMqruEjRp
         QqFBChpXsgY7z++7MENVyD+AhX8CV+7BaN84LBse8+Wh9Ylinyt+PGGqAAehi9E6OFY1
         XgOQ==
X-Gm-Message-State: AOAM531KXkVZtN77KhCjkySQ1gTaTnNTKR39lqnkCPTubkUl2DQxgkxm
	AT5mfIJMfWbUR9e2ti8HhR1//WGtWhcUMFqYc1AxKQ==
X-Google-Smtp-Source: ABdhPJwu7flVE67Zd28ydBqsaVlXmqVhbsBjuDcQx7XQgSdNuJ71Ra9vq5CV/TY0xTtPZK8VxEMd4grPCznabbW55PA=
X-Received: by 2002:a63:85c6:: with SMTP id u189mr18413808pgd.437.1643673614974;
 Mon, 31 Jan 2022 16:00:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
 <164298422510.3018233.14693126572756675563.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20220131162251.000023fe@Huawei.com>
In-Reply-To: <20220131162251.000023fe@Huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 31 Jan 2022 16:00:07 -0800
Message-ID: <CAPcyv4hcE+4Vt1KZ4HB74ScSt9rEF4HO_TX+H1KyMN=ew=EOzg@mail.gmail.com>
Subject: Re: [PATCH v3 20/40] cxl/pci: Rename pci.h to cxlpci.h
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, kernel test robot <lkp@intel.com>, 
	Linux PCI <linux-pci@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jan 31, 2022 at 8:35 AM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Sun, 23 Jan 2022 16:30:25 -0800
> Dan Williams <dan.j.williams@intel.com> wrote:
>
> > Similar to the mem.h rename, if the core wants to reuse definitions from
> > drivers/cxl/pci.h it is unable to use <pci.h> as that collides with
> > archs that have an arch/$arch/include/asm/pci.h, like MIPS.
> >
> > Reported-by: kernel test robot <lkp@intel.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> Does this perhaps want a fixes tag?
>

It doesn't need one because it's not until this set that the
drivers/cxl/core/ reaches out of its own directory to include this.
