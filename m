Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274DF2F21
	for <nvdimm@lists.linux.dev>; Mon,  7 Feb 2022 11:54:03 +0000 (UTC)
Received: by mail-ot1-f42.google.com with SMTP id n6-20020a9d6f06000000b005a0750019a7so10678190otq.5
        for <nvdimm@lists.linux.dev>; Mon, 07 Feb 2022 03:54:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0wPDtA/8dQY/zt6gEOJb8muHJfhFJHLN9w+AJsq2qv8=;
        b=Yq2ZfuDnaCP7+Zjic66gYVOgXET4dQYW6dH+Mb63R/XwoD3Ju1QLZWom1oF+pljSMe
         G+1VACKUSZ4Kgm9BmF1Vs7Ghq6Yh9PCKT/OiTMrJ/ZlxIGZzgjTUK3ACURS/i9Y1nG4d
         /lDsVTb+14gtrmFwugTl47Uv54fBCtKBP6akpwUGmXe1+AomIj488INIXhl4ci/4LPkd
         NwRabfaO5HczGWGc5bT/rYGYWrG7u/LbEi/pS/QBT0inrDbiNk+qHtdFulMR+l9p1dLu
         vWhaRlMycI80TXwUiMrevIHb8lbpg7uXmulW0Tgn7in5bv+C6gWtfEGgy49eZK4Sle1e
         zkfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0wPDtA/8dQY/zt6gEOJb8muHJfhFJHLN9w+AJsq2qv8=;
        b=qKIrl96O4FeJEmFxeqLX6fLzsD9fugHTYvFK+BfjBs6r+UVXISI/hAR5lMnPsw/kDv
         o4rXE2tx/JT4X62OsmEhvpqaC5XMwvVomZtf1ztFLwBdApAL+j4KxSV6y9p5PI0C0Cpg
         CCN2McWvNROAZDiwul6pBY+rEmqHpzFuC7pu0ZIoO0Ytow2C0D/Wly82vZ/5UYndqYaT
         8RVdqfsAUYLqA8JlGPIEOg+1zocG8rmJ/MxLVPiatDU8FnTS1ncvESIIZc+7JKRaepHr
         OdGpQaDlS4zig5Ymd4070Ph7HUPGlRe3K3xGdYLbRavJetpJDtEQlIDXbyHiQVapaofq
         tuNg==
X-Gm-Message-State: AOAM5300YhVb9Ooi55BTEK/SV7NvF6HgszUuJHy8FcAIWNxPb4wmWb7e
	WrcisaHSeMiaAlFbnZI4QWQ=
X-Google-Smtp-Source: ABdhPJyK2ZOF1n2ZjcUVDShZFG9nZhSBCVpygtRGNJQFmjrqt3pYzHAHUGhB1NKJEMsdBCu0nwcWpQ==
X-Received: by 2002:a05:6830:1084:: with SMTP id y4mr3858234oto.42.1644234842231;
        Mon, 07 Feb 2022 03:54:02 -0800 (PST)
Received: from [192.168.10.222] ([191.193.0.12])
        by smtp.gmail.com with ESMTPSA id d22sm3748614otp.79.2022.02.07.03.53.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 03:54:01 -0800 (PST)
Message-ID: <6768501a-0cf8-a2d9-df73-5e8185b433fb@gmail.com>
Date: Mon, 7 Feb 2022 08:53:57 -0300
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v7 0/3] spapr: nvdimm: Introduce spapr-nvdimm device
Content-Language: en-US
To: Shivaprasad G Bhat <sbhat@linux.ibm.com>, clg@kaod.org, mst@redhat.com,
 ani@anisinha.ca, david@gibson.dropbear.id.au, groug@kaod.org,
 imammedo@redhat.com, xiaoguangrong.eric@gmail.com, qemu-ppc@nongnu.org
Cc: qemu-devel@nongnu.org, aneesh.kumar@linux.ibm.com,
 nvdimm@lists.linux.dev, kvm-ppc@vger.kernel.org
References: <164396252398.109112.13436924292537517470.stgit@ltczzess4.aus.stglabs.ibm.com>
From: Daniel Henrique Barboza <danielhb413@gmail.com>
In-Reply-To: <164396252398.109112.13436924292537517470.stgit@ltczzess4.aus.stglabs.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/4/22 05:15, Shivaprasad G Bhat wrote:
> If the device backend is not persistent memory for the nvdimm, there
> is need for explicit IO flushes to ensure persistence.
> 
> On SPAPR, the issue is addressed by adding a new hcall to request for
> an explicit flush from the guest when the backend is not pmem.
> So, the approach here is to convey when the hcall flush is required
> in a device tree property. The guest once it knows the device needs
> explicit flushes, makes the hcall as and when required.
> 
> It was suggested to create a new device type to address the
> explicit flush for such backends on PPC instead of extending the
> generic nvdimm device with new property. So, the patch introduces
> the spapr-nvdimm device. The new device inherits the nvdimm device
> with the new bahviour such that if the backend has pmem=no, the
> device tree property is set by default.
> 
> The below demonstration shows the map_sync behavior for non-pmem
> backends.
> (https://github.com/avocado-framework-tests/avocado-misc-tests/blob/master/memory/ndctl.py.data/map_sync.c)
> 
> The pmem0 is from spapr-nvdimm with with backend pmem=on, and pmem1 is
> from spapr-nvdimm with pmem=off, mounted as
> /dev/pmem0 on /mnt1 type xfs (rw,relatime,attr2,dax=always,inode64,logbufs=8,logbsize=32k,noquota)
> /dev/pmem1 on /mnt2 type xfs (rw,relatime,attr2,dax=always,inode64,logbufs=8,logbsize=32k,noquota)
> 
> [root@atest-guest ~]# ./mapsync /mnt1/newfile ----> When pmem=on
> [root@atest-guest ~]# ./mapsync /mnt2/newfile ----> when pmem=off
> Failed to mmap  with Operation not supported
> 
> First patch adds the realize/unrealize call backs to the generic device
> for the new device's vmstate registration. The second patch implements
> the hcall, adds the necessary vmstate properties to spapr machine structure
> for carrying the hcall status during save-restore. The nature of the hcall
> being asynchronus, the patch uses aio utilities to offload the flush. The
> third patch introduces the spapr-nvdimm device, adds the device tree
> property for the guest when spapr-nvdimm is used with pmem=no on the
> backend. Also adds new property pmem-override(?, suggest if you have better
> name) to the spapr-nvdimm which hints at forcing the hcall based flushes even
> on pmem backed devices.
> 
> The kernel changes to exploit this hcall is at
> https://github.com/linuxppc/linux/commit/75b7c05ebf9026.patch
> 
> ---

I noted that we have only two nvdimm tests in QEMU, both in tests/qtest/bios-tables-test.c.
It would be a good future improvement to add some spapr-nvdimm tests there as well.


Thanks,


Daniel


> v6 - https://lists.gnu.org/archive/html/qemu-devel/2022-02/msg00322.html
> Changes from v6:
>        - Addressed commen from Daniel.
>          Fixed a typo
>          Fetch the memory backend FD in the flush_worker_cb(), updated hcall
>          return values in the comments description)
>        - Updated the signatures.
> 
> v5 - https://lists.gnu.org/archive/html/qemu-devel/2021-07/msg01741.html
> Changes from v5:
>        - Taken care of all comments from David
>        - Moved the flush lists from spapr machine into the spapr-nvdimm device
>          state structures. So, all corresponding data structures adjusted
> 	accordingly as required.
>        - New property pmem-overrride is added to the spapr-nvdimm device. The
>          hcall flushes are allowed when pmem-override is set for the device.
>        - The flush for pmem backend devices are made to use pmem_persist().
>        - The vmstate structures are also made part of device state instead of
>          global spapr.
>        - Passing the flush token to destination during migration, I think its
>          better than finding, deriving it from the outstanding ones.
> 
> v4 - https://lists.gnu.org/archive/html/qemu-devel/2021-04/msg05982.html
> Changes from v4:
>        - Introduce spapr-nvdimm device with nvdimm device as the parent.
>        - The new spapr-nvdimm has no new properties. As this is a new
>          device and there is no migration related dependencies to be
>          taken care of, the device behavior is made to set the device tree
>          property and enable hcall when the device type spapr-nvdimm is
>          used with pmem=off
>        - Fixed commit messages
>        - Added checks to ensure the backend is actualy file and not memory
>        - Addressed things pointed out by Eric
> 
> v3 - https://lists.gnu.org/archive/html/qemu-devel/2021-03/msg07916.html
> Changes from v3:
>        - Fixed the forward declaration coding guideline violations in 1st patch.
>        - Removed the code waiting for the flushes to complete during migration,
>          instead restart the flush worker on destination qemu in post load.
>        - Got rid of the randomization of the flush tokens, using simple
>          counter.
>        - Got rid of the redundant flush state lock, relying on the BQL now.
>        - Handling the memory-backend-ram usage
>        - Changed the sync-dax symantics from on/off to 'unsafe','writeback' and 'direct'.
> 	Added prevention code using 'writeback' on arm and x86_64.
>        - Fixed all the miscellaneous comments.
> 
> v2 - https://lists.gnu.org/archive/html/qemu-devel/2020-11/msg07031.html
> Changes from v2:
>        - Using the thread pool based approach as suggested
>        - Moved the async hcall handling code to spapr_nvdimm.c along
>          with some simplifications
>        - Added vmstate to preserve the hcall status during save-restore
>          along with pre_save handler code to complete all ongoning flushes.
>        - Added hw_compat magic for sync-dax 'on' on previous machines.
>        - Miscellanious minor fixes.
> 
> v1 - https://lists.gnu.org/archive/html/qemu-devel/2020-11/msg06330.html
> Changes from v1
>        - Fixed a missed-out unlock
>        - using QLIST_FOREACH instead of QLIST_FOREACH_SAFE while generating token
> 
> Shivaprasad G Bhat (3):
>        nvdimm: Add realize, unrealize callbacks to NVDIMMDevice class
>        spapr: nvdimm: Implement H_SCM_FLUSH hcall
>        spapr: nvdimm: Introduce spapr-nvdimm device
> 
> 
>   hw/mem/nvdimm.c               |  16 ++
>   hw/mem/pc-dimm.c              |   5 +
>   hw/ppc/spapr.c                |   2 +
>   hw/ppc/spapr_nvdimm.c         | 394 ++++++++++++++++++++++++++++++++++
>   include/hw/mem/nvdimm.h       |   2 +
>   include/hw/mem/pc-dimm.h      |   1 +
>   include/hw/ppc/spapr.h        |   4 +-
>   include/hw/ppc/spapr_nvdimm.h |   1 +
>   8 files changed, 424 insertions(+), 1 deletion(-)
> 
> --
> Signature
> 
