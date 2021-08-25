Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338203FC0
	for <nvdimm@lists.linux.dev>; Wed, 25 Aug 2021 22:05:27 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id oc2-20020a17090b1c0200b00179e56772d6so5048098pjb.4
        for <nvdimm@lists.linux.dev>; Wed, 25 Aug 2021 15:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zbgcy0H2XZaZpgH1WoNm2chkRPcTPJCJf59MVEDZuME=;
        b=pLgTZL9a1yfukekaD2fYYpMt6/7pL54S6kNuEeF+Go0UIm6bT4KvG5MqmpapljtXCT
         3Gs5JvhHXX8spV+rgpQsm09hRLYO/ZJgJ+BKwEUR8LGp83j9C3nPZcfOla7hkZX55aqO
         BsGEMst4M3vRwFrNbgaIocYSU/HkSr/pc2CLt/k44oPQIL1kbSh8iocueTrae1XI0lcV
         FACnRO3QbvCuOZ1RDL8heQroHO/mK9eEGtVKM6jnv5MpEdNif/DT8dsGuItq/5SKXkvn
         85R+R2HmJC++3+c4GHxRYyUKJesd7miaZglOoDdzO/4LbcWD3o1kdHzAGSrmlLAPG5t8
         2jiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zbgcy0H2XZaZpgH1WoNm2chkRPcTPJCJf59MVEDZuME=;
        b=siwQbzgkFiVP6nfZ+SoSR05+/lVs27UhPpGvPKabErbhHkMTK1GheIzpV91poJejfS
         MK/c9cQ1jkTh2IhAgSN7Nv2OXEMPzl4iUeHysNrqvv08eblO0KsyARy0PF7luVi0lf+K
         cyb3XxXYkiKepa0fXz2QR0Ywc06EKkzXHe0Aulb8oKWPPVC2UCnbBa2TU98+zq5KnWul
         QE/hKyq49aLABOEHUq7bRlmckV4vz6bjSeMU7IOutwXM9WQNHJGRIlRDRsvtDy3caivl
         cLFYiWTpcAJBdCcW2bPZjxWs1JEhShP5mAu+rkIDWjOnTk1neffEOqfzYGByX+K1tf5W
         6raQ==
X-Gm-Message-State: AOAM533kCGQnV6/bqGjG/DiOXxLMF10E22pDJSdzihH4H6ZWCpIeg749
	pf0DvxD4yoPFN0hz1Rte9O0dash25NKirxBG2GNurQ==
X-Google-Smtp-Source: ABdhPJyhNAtBF1kxYhaMw72sH8vmiiKDmiSZ1Ajm/UP9/+mObdNBqTSCIA/L9nxMvUapBFtWeNdrb4EHFCW0GauQIfM=
X-Received: by 2002:a17:90a:1991:: with SMTP id 17mr4312708pji.149.1629929126746;
 Wed, 25 Aug 2021 15:05:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210715223324.GA29063@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CAPcyv4gKqK6Mi6-PT0Mo=P=gBvMkA2zK1Huo3f2aAKYAP3SCVg@mail.gmail.com> <20210825215622.GB3868@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
In-Reply-To: <20210825215622.GB3868@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 25 Aug 2021 15:05:16 -0700
Message-ID: <CAPcyv4i0PYOJthSs0UmgOAXSVZ0ggQNnS86ViLKVfCz8Bv0dgQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] virtio-pmem: Support PCI BAR-relative addresses
To: Taylor Stark <tstark@linux.microsoft.com>
Cc: Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	"Weiny, Ira" <ira.weiny@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, apais@microsoft.com, 
	tyhicks@microsoft.com, jamorris@microsoft.com, benhill@microsoft.com, 
	sunilmut@microsoft.com, grahamwo@microsoft.com, tstark@microsoft.com
Content-Type: text/plain; charset="UTF-8"

On Wed, Aug 25, 2021 at 2:56 PM Taylor Stark <tstark@linux.microsoft.com> wrote:
>
> On Tue, Aug 24, 2021 at 05:35:48PM -0700, Dan Williams wrote:
> > On Thu, Jul 15, 2021 at 3:34 PM Taylor Stark <tstark@linux.microsoft.com> wrote:
> > >
> > > Changes from v1 [1]:
> > >  - Fixed a bug where the guest might touch pmem region prior to the
> > >    backing file being mapped into the guest's address space.
> > >
> > > [1]: https://www.mail-archive.com/linux-nvdimm@lists.01.org/msg23736.html
> > >
> > > ---
> > >
> > > These patches add support to virtio-pmem to allow the pmem region to be
> > > specified in either guest absolute terms or as a PCI BAR-relative address.
> > > This is required to support virtio-pmem in Hyper-V, since Hyper-V only
> > > allows PCI devices to operate on PCI memory ranges defined via BARs.
> > >
> > > Taylor Stark (2):
> > >   virtio-pmem: Support PCI BAR-relative addresses
> > >   virtio-pmem: Set DRIVER_OK status prior to creating pmem region
> >
> > Are these patches still valid? I am only seeing one of them on the list.
>
> I'd hold off on taking a look for now. I'll need to post a v3 based on some
> suggestions while I was updating the virtio-pmem spec. It's a small change
> compared to the current patches (adds in a feature bit check). I'll post v3
> when the virtio-pmem base spec goes in. More info here:
>
> https://lists.oasis-open.org/archives/virtio-comment/202107/msg00169.html
>
> And yes, I messed up how I sent the patches. First time making linux changes,
> so I had some bumps while getting my email properly configured.. :)

No worries, yes it's a pain. It turns out Konstantin is trying to make
that process easier for new contributors:

https://lore.kernel.org/workflows/20210616171813.bwvu6mtl4ltotf7p@nitro.local/

...but I don't think that's up and running yet.
