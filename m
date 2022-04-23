Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1197A
	for <nvdimm@lists.linux.dev>; Sat, 23 Apr 2022 17:29:13 +0000 (UTC)
Received: by mail-pf1-f169.google.com with SMTP id w16so4503197pfj.2
        for <nvdimm@lists.linux.dev>; Sat, 23 Apr 2022 10:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AhQD7vPYfAiEn+1RfQt67d4Dixq2S1YB+w4qj2jR+Q0=;
        b=xWKXKc58HUkxMRuDr/Zf6Aje7ybvTzC671zQtfNEALotesIZAxNUc2OGEA4z3Ra7Of
         lkStFa3Uxdix3cOJZDYBHyrFCMutNH68Gfit3R7u95+uMerV4inCdkX5tYTlb8bQppfP
         GVMOpuVsU+PKBwwRm8845rgsfzOkwkig89/gchUiiMe/tlrxvF59A4OkCGpnAU51r+CT
         SOqoDAkKyGT2546Nu4M586YH6iQFI0TriSPXJ4zKHuLS6E7GYPU0KRqyP+1sSitkfvyE
         /jlefNOpENa3XDJsSmPdNtL9DWk2ne95gAtVj79KvvOsDK8Xv5GoLzI4lnGOadxL3lh/
         XALg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AhQD7vPYfAiEn+1RfQt67d4Dixq2S1YB+w4qj2jR+Q0=;
        b=BqAtCn90ewqe9c4Bgkrzzs0wuZiD1GGffaaxKWRXTsUwKdLW8+18vb/LOLmJ9TrU8i
         +PZWWMxdCS9AOq4j8KY58Lngesl6QqPN5lv7PcSj+xOEpGeSnxeb8R/fDxsrTQyaVcXP
         eQUqsUwRBq71nWhhIiCTz5nK/eb2qC7v+PWwNIAPCnrzltH8g/fEx5+2vkfAKRGIUVwq
         rJjyU5/Iv4Y/czLyWlLfgpCSFqjU0Pdp4usnGCNtSSheLGlQ+jy8gB3cQRUNOA6uJcxE
         6tL1NLW1UEAw6hukR2Ii2OpzL1Rw9NmizPTiQkRdCnEpx3paEx3MnsfEaFfetB0nLHAE
         p2mg==
X-Gm-Message-State: AOAM530HFchTpr5NZ1tdm+zqnjzXvCneVbW+Kkt04DbEZpIqf6TEd8M4
	G0sGE5Q1HPAmZVplLoc3mtqSMU1CTALne3kV2vKYXg==
X-Google-Smtp-Source: ABdhPJxHuHMaqsEKztBmTLaKInseY99XjI/+A47OoxmxiEuZUwC9WyROijbh+f6qYfCWMeRmXPrwJ1l3eN2+M0oAWek=
X-Received: by 2002:a65:6e0e:0:b0:399:26d7:a224 with SMTP id
 bd14-20020a656e0e000000b0039926d7a224mr8657810pgb.437.1650734952939; Sat, 23
 Apr 2022 10:29:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <165055518776.3745911.9346998911322224736.stgit@dwillia2-desk3.amr.corp.intel.com>
 <165055523099.3745911.9091010720291846249.stgit@dwillia2-desk3.amr.corp.intel.com>
 <YmOAXqOIW7DE0nMR@iweiny-desk3>
In-Reply-To: <YmOAXqOIW7DE0nMR@iweiny-desk3>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 23 Apr 2022 10:29:02 -0700
Message-ID: <CAPcyv4gOBypbVV8dCrR6xWGSv0EA0sAVyNNwah1=d-hkuV3A_Q@mail.gmail.com>
Subject: Re: [PATCH v3 8/8] nvdimm: Fix firmware activation deadlock scenarios
To: Ira Weiny <ira.weiny@intel.com>
Cc: linux-cxl@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Vishal L Verma <vishal.l.verma@intel.com>, "Schofield, Alison" <alison.schofield@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Apr 22, 2022 at 9:28 PM Ira Weiny <ira.weiny@intel.com> wrote:
>
> On Thu, Apr 21, 2022 at 08:33:51AM -0700, Dan Williams wrote:
> > Lockdep reports the following deadlock scenarios for CXL root device
> > power-management, device_prepare(), operations, and device_shutdown()
> > operations for 'nd_region' devices:
> >
> > ---
> >  Chain exists of:
> >    &nvdimm_region_key --> &nvdimm_bus->reconfig_mutex --> system_transition_mutex
> >
> >   Possible unsafe locking scenario:
> >
> >         CPU0                    CPU1
> >         ----                    ----
> >    lock(system_transition_mutex);
> >                                 lock(&nvdimm_bus->reconfig_mutex);
> >                                 lock(system_transition_mutex);
> >    lock(&nvdimm_region_key);
> >
> > --
> >
> >  Chain exists of:
> >    &cxl_nvdimm_bridge_key --> acpi_scan_lock --> &cxl_root_key
> >
> >   Possible unsafe locking scenario:
> >
> >         CPU0                    CPU1
> >         ----                    ----
> >    lock(&cxl_root_key);
> >                                 lock(acpi_scan_lock);
> >                                 lock(&cxl_root_key);
> >    lock(&cxl_nvdimm_bridge_key);
> >
> > ---
> >
> > These stem from holding nvdimm_bus_lock() over hibernate_quiet_exec()
> > which walks the entire system device topology taking device_lock() along
> > the way. The nvdimm_bus_lock() is protecting against unregistration,
> > multiple simultaneous ops callers, and preventing activate_show() from
> > racing activate_store(). For the first 2, the lock is redundant.
> > Unregistration already flushes all ops users, and sysfs already prevents
> > multiple threads to be active in an ops handler at the same time. For
> > the last userspace should already be waiting for its last
> > activate_store() to complete, and does not need activate_show() to flush
> > the write side, so this lock usage can be deleted in these attributes.
> >
>
> I'm sorry if this is obvious but why can't the locking be removed from
> capability_show() and nvdimm_bus_firmware_visible() as well?

It can, that's a good catch, thanks.
