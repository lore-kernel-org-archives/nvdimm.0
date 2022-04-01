Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BFF87C
	for <nvdimm@lists.linux.dev>; Fri,  1 Apr 2022 03:44:54 +0000 (UTC)
Received: by mail-yb1-f169.google.com with SMTP id e203so2799309ybc.12
        for <nvdimm@lists.linux.dev>; Thu, 31 Mar 2022 20:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9B4WEZ0kLlULB4LbFV1XobrJLY80bQg04fCEt2tmBh0=;
        b=Y5Oi0XEb+emxKId7bsagdXSU46iQ3M4G7YWRo7v0aGa14BtedtPxqacq4GwuPr4Dc6
         OKF2c/B49cKSL5s2Pq+gM6/QlH1jKMVvOI9Yc57Ox5I9UhgYIT842/vzVHYHfEZaIRLK
         8WR/Z/8h/3XTFhGw8F+mCAN+wv0ULsIoJQy+b0NP70JVHm5K0sS2QMERJ16TgpBUzKVY
         2hitjcbJVCQmmqF3yzQ1T/RvcOhpEbPmcVBqLMDYTn7GpFqlw/nqu6WKYEiGOLIdaaXN
         Ux4bpA/NzHyb9IWwZFokii3cCf2lde8UyD0dzspodcrC5bLilTpUs5RsspzVOaE3yGy2
         4oWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9B4WEZ0kLlULB4LbFV1XobrJLY80bQg04fCEt2tmBh0=;
        b=EdgsCRKg1wgofG80472Z/v5qxqKSDhb7m+PgVDoxJRPcohSXXbKp5B0niF6iXiNEkq
         QO02r/mAq47nqCXIIEuddT5PDEX2OXRg83EUgVMOyJ/PWayR+WhZSOSa2gYz4Ce7gcil
         aLV/6UlUl7kEmLQuXUJNValfx2/K3FBWDtJvI82v5fQroPDKtKS2cmr/zRfTMV6gAGRN
         LCh07pfcNmSsBNhzoQCtMPkx6kEdff81CR+Phlgv+Le9E5AJyfBV51QsW+vBymAsIs72
         J37R+CPDJ+P74NnQdtx/hamyghMO9wxF6JYRV1Uk9BXwZe2wLixkbc87O9DKPMHVqW0U
         wuSA==
X-Gm-Message-State: AOAM530FHN3pJb2SrVX+UKVOwumzwL0j8vPprigmKKfFD7kiFBliuFca
	WDmqCh8Rg3kkmQ5PPRd2++Rhqjgqh99AhGy/elLvKw==
X-Google-Smtp-Source: ABdhPJzX84Ur/n5RFYt0A3CrndUWTYNIbMp90aUIgpXwyQ2odjEMHe+i0yF9nxIqSsb7ovr2tCTq6k63+JOoGp14jJU=
X-Received: by 2002:a25:c049:0:b0:634:6751:e8d2 with SMTP id
 c70-20020a25c049000000b006346751e8d2mr7192510ybf.6.1648784693186; Thu, 31 Mar
 2022 20:44:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220318074529.5261-1-songmuchun@bytedance.com> <YkXPA69iLBDHFtjn@qian>
In-Reply-To: <YkXPA69iLBDHFtjn@qian>
From: Muchun Song <songmuchun@bytedance.com>
Date: Fri, 1 Apr 2022 11:44:16 +0800
Message-ID: <CAMZfGtWFg=khjaHsjeHA24G8DMbjbRYRhGytBHaD7FbORa+iMg@mail.gmail.com>
Subject: Re: [PATCH v5 0/6] Fix some bugs related to ramp and dax
To: Qian Cai <quic_qiancai@quicinc.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Andrew Morton <akpm@linux-foundation.org>, Alistair Popple <apopple@nvidia.com>, 
	Yang Shi <shy828301@gmail.com>, Ralph Campbell <rcampbell@nvidia.com>, 
	Hugh Dickins <hughd@google.com>, Xiyu Yang <xiyuyang19@fudan.edu.cn>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Ross Zwisler <zwisler@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, LKML <linux-kernel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, Xiongchun duan <duanxiongchun@bytedance.com>, 
	Muchun Song <smuchun@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 31, 2022 at 11:55 PM Qian Cai <quic_qiancai@quicinc.com> wrote:
>
> On Fri, Mar 18, 2022 at 03:45:23PM +0800, Muchun Song wrote:
> > This series is based on next-20220225.
> >
> > Patch 1-2 fix a cache flush bug, because subsequent patches depend on
> > those on those changes, there are placed in this series.  Patch 3-4
> > are preparation for fixing a dax bug in patch 5.  Patch 6 is code clean=
up
> > since the previous patch remove the usage of follow_invalidate_pte().
>
> Reverting this series fixed boot crashes.
>
>  KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
>  Mem abort info:
>    ESR =3D 0x96000004
>    EC =3D 0x25: DABT (current EL), IL =3D 32 bits
>    SET =3D 0, FnV =3D 0
>    EA =3D 0, S1PTW =3D 0
>    FSC =3D 0x04: level 0 translation fault
>  Data abort info:
>    ISV =3D 0, ISS =3D 0x00000004
>    CM =3D 0, WnR =3D 0
>  [dfff800000000003] address between user and kernel address ranges
>  Internal error: Oops: 96000004 [#1] PREEMPT SMP
>  Modules linked in: cdc_ether usbnet ipmi_devintf ipmi_msghandler cppc_cp=
ufreq fuse ip_tables x_tables ipv6 btrfs blake2b_generic libcrc32c xor xor_=
neon raid6_pq zstd_compress dm_mod nouveau crct10dif_ce drm_ttm_helper mlx5=
_core ttm drm_dp_helper drm_kms_helper nvme mpt3sas nvme_core xhci_pci raid=
_class drm xhci_pci_renesas
>  CPU: 3 PID: 1707 Comm: systemd-udevd Not tainted 5.17.0-next-20220331-00=
004-g2d550916a6b9 #51
>  pstate: 104000c9 (nzcV daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=3D--)
>  pc : __lock_acquire
>  lr : lock_acquire.part.0
>  sp : ffff800030a16fd0
>  x29: ffff800030a16fd0 x28: ffffdd876c4e9f90 x27: 0000000000000018
>  x26: 0000000000000000 x25: 0000000000000018 x24: 0000000000000000
>  x23: ffff08022beacf00 x22: ffffdd8772507660 x21: 0000000000000000
>  x20: 0000000000000000 x19: 0000000000000000 x18: ffffdd8772417d2c
>  x17: ffffdd876c5bc2e0 x16: 1fffe100457d5b06 x15: 0000000000000094
>  x14: 000000000000f1f1 x13: 00000000f3f3f3f3 x12: ffff08022beacf08
>  x11: 1ffffbb0ee482fa5 x10: ffffdd8772417d28 x9 : 0000000000000000
>  x8 : 0000000000000003 x7 : ffffdd876c4e9f90 x6 : 0000000000000000
>  x5 : 0000000000000000 x4 : 0000000000000001 x3 : 0000000000000000
>  x2 : 0000000000000000 x1 : 0000000000000003 x0 : dfff800000000000
>  Call trace:
>   __lock_acquire
>   lock_acquire.part.0
>   lock_acquire
>   _raw_spin_lock
>   page_vma_mapped_walk
>   try_to_migrate_one
>   rmap_walk_anon
>   try_to_migrate
>   __unmap_and_move
>   unmap_and_move
>   migrate_pages
>   migrate_misplaced_page
>   do_huge_pmd_numa_page
>   __handle_mm_fault
>   handle_mm_fault
>   do_translation_fault
>   do_mem_abort
>   el0_da
>   el0t_64_sync_handler
>   el0t_64_sync
>  Code: d65f03c0 d343ff61 d2d00000 f2fbffe0 (38e06820)
>  ---[ end trace 0000000000000000 ]---
>  Kernel panic - not syncing: Oops: Fatal exception
>  SMP: stopping secondary CPUs
>  Kernel Offset: 0x5d8763da0000 from 0xffff800008000000
>  PHYS_OFFSET: 0x80000000
>  CPU features: 0x000,00085c0d,19801c82
>  Memory Limit: none
>  ---[ end Kernel panic - not syncing: Oops: Fatal exception ]---

Thanks for your report. Would you mind providing the .config?
