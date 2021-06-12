Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C123173
	for <nvdimm@lists.linux.dev>; Sat, 12 Jun 2021 00:07:44 +0000 (UTC)
Received: by mail-pj1-f41.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso8026583pjx.1
        for <nvdimm@lists.linux.dev>; Fri, 11 Jun 2021 17:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hGLFyLESMIgo99vWAnXA3J0lKjK1kQXAD/JyJ1aKsZk=;
        b=QbII9VgB8n74k5K/jFnXpmVK+M1t2h2uYfthcmYVLcLX21+gOXDCMUJ2OEvFRQtZth
         uYhUA0p47+XXAKEXbdlxQeeCpaHRpGsQLd0w/hiz3Me5wpQZD4jiucHL7pUZwj8HbRau
         C2164UGRNBNojotFntcaX1wN4KWUYUNLo5063jEvJy5RFX8h7v6pQPCXLnULVzu2ZTVw
         sqK9AUWZC9WC5ee6tXU84/HUR+5gT1d29ArWcOOss6OZMY2MfFuvU6JyZ5H+aiAK8LZu
         3KF4/t9qw/CgrlcHEqkct40QF2AdfABFL6/vqUCj1/55MuZ/zEEG9RNNAiozR75RgmXL
         CTqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hGLFyLESMIgo99vWAnXA3J0lKjK1kQXAD/JyJ1aKsZk=;
        b=AZWHPiMD4FRK9CSjBfeKQt4+m2Hmxp6VDrjDJSnd+jHri35RrJ4ehEviJO5A9Bbs/G
         uYghHUZTlUNGg4FNnjNqHMwnvDB43+begODUfsLACsNE1JDiNldLWppNNtvVcXdb4E12
         bDKNMJLfRhK/f4M2/3Iy8iAaGN1nXzIbEPBolRENemZqzSxE3ws1f1nj2JpHysWC066p
         tzT/S0m3dAVEVSqIjVyXOPM1USV//tVRCKjoQOL5zyFS/S0Fb3cxuvMmGk+sj6H79LmG
         QFkV7u/+5egAe4EDGEYp6NzMBRPqA7MDXtwC/Riez0QmrRnH6G8pu+KjO5xXGXNQ6oLK
         WM3g==
X-Gm-Message-State: AOAM533hqzKB0q8kFBZ9R9e1wIeNorbX7Oe4YXucYaOWP6U5G4UJKLvk
	cZTEHPA8ioIEflF7DP07jOK/w2Gi1EbmyquT5svq1A==
X-Google-Smtp-Source: ABdhPJzWnHWBBuelObRnLJjV0cwtOackeAz3RyD+CKkcuWLFAmuidh4v8+rcKDkgjSaaI097BNGGhzQAwSEoie+Ek/A=
X-Received: by 2002:a17:902:f1cb:b029:10c:5c6d:88b with SMTP id
 e11-20020a170902f1cbb029010c5c6d088bmr6253794plc.52.1623456463807; Fri, 11
 Jun 2021 17:07:43 -0700 (PDT)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <162336395765.2462439.11368504490069925374.stgit@dwillia2-desk3.amr.corp.intel.com>
 <162336396844.2462439.1234951573910835450.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210611123953.000054df@Huawei.com>
In-Reply-To: <20210611123953.000054df@Huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 11 Jun 2021 17:07:32 -0700
Message-ID: <CAPcyv4hU-b1=5eAn=Fs65AwYMQj58txMj_D3Y_Ynq72QO-qJrQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] cxl/pmem: Add initial infrastructure for pmem support
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Ben Widawsky <ben.widawsky@intel.com>, "Schofield, Alison" <alison.schofield@intel.com>, 
	Vishal L Verma <vishal.l.verma@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Jun 11, 2021 at 4:40 AM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Thu, 10 Jun 2021 15:26:08 -0700
> Dan Williams <dan.j.williams@intel.com> wrote:
>
> > Register an 'nvdimm-bridge' device to act as an anchor for a libnvdimm
> > bus hierarchy. Also, flesh out the cxl_bus definition to allow a
> > cxl_nvdimm_bridge_driver to attach to the bridge and trigger the
> > nvdimm-bus registration.
> >
> > The creation of the bridge is gated on the detection of a PMEM capable
> > address space registered to the root. The bridge indirection allows the
> > libnvdimm module to remain unloaded on platforms without PMEM support.
> >
> > Given that the probing of ACPI0017 is asynchronous to CXL endpoint
> > devices, and the expectation that CXL endpoint devices register other
> > PMEM resources on the 'CXL' nvdimm bus, a workqueue is added. The
> > workqueue is needed to run bus_rescan_devices() outside of the
> > device_lock() of the nvdimm-bridge device to rendezvous nvdimm resources
> > as they arrive. For now only the bus is taken online/offline in the
> > workqueue.
> >
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> I'm not that familiar with nvdimm side of things, so this is mostly
> superficial review of the patch itself.
>
> A few really minor comments inline, but otherwise looks good to me.
>
> Jonathan
>
[..]
> > +static void unregister_nvb(void *_cxl_nvb)
> > +{
> > +     struct cxl_nvdimm_bridge *cxl_nvb = _cxl_nvb;
> > +     bool flush = false;
> > +
> > +     /*
> > +      * If the bridge was ever activated then there might be in-flight state
> > +      * work to flush. Once the state has been changed to 'dead' then no new
> > +      * work can be queued by user-triggered bind.
> > +      */
> > +     device_lock(&cxl_nvb->dev);
> > +     if (cxl_nvb->state != CXL_NVB_NEW)
> > +             flush = true;
>
> flush = clx_nvb->state != CXL_NVB_NEW;
>
> perhaps?

Oh, yeah, that's nicer.

[..]
> > +static void cxl_nvb_update_state(struct work_struct *work)
> > +{
> > +     struct cxl_nvdimm_bridge *cxl_nvb =
> > +             container_of(work, typeof(*cxl_nvb), state_work);
> > +     bool release = false;
> > +
> > +     device_lock(&cxl_nvb->dev);
> > +     switch (cxl_nvb->state) {
> > +     case CXL_NVB_ONLINE:
> > +             online_nvdimm_bus(cxl_nvb);
> > +             if (!cxl_nvb->nvdimm_bus) {
>
> I'd slightly prefer a simple return code from online_nvdimm_bus()
> so the reviewer doesn't have to look up above to find out that
> this condition corresponds to failure.

Yeah, not sure why I made that so obscure.
