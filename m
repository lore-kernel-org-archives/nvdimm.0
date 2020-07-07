Return-Path: <SRS0=hiqq=AS=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74ED7C433DF
	for <linux-nvdimm@archiver.kernel.org>; Tue,  7 Jul 2020 10:06:24 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 482F020739
	for <linux-nvdimm@archiver.kernel.org>; Tue,  7 Jul 2020 10:06:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 482F020739
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 2252811075BCD;
	Tue,  7 Jul 2020 03:06:24 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=209.85.221.66; helo=mail-wr1-f66.google.com; envelope-from=mstsxfx@gmail.com; receiver=<UNKNOWN> 
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com [209.85.221.66])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 85360100780A2
	for <linux-nvdimm@lists.01.org>; Tue,  7 Jul 2020 03:06:21 -0700 (PDT)
Received: by mail-wr1-f66.google.com with SMTP id r12so44444649wrj.13
        for <linux-nvdimm@lists.01.org>; Tue, 07 Jul 2020 03:06:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=23vy72E5orNjWgQ+h1yoOH9UAR+rJOK6XwpQtfEVuLc=;
        b=ZB80/7FA7731cQStcFdugv/mMiwgNT/aNBAILCmo9rFBwHFtrgDeSwap0U3lVAEoC4
         A9Fh+0+9YnMnpeZuxDMbC4cA+HH3ek4FbNT52R1xs2GJIuUVkkOs5NPEWmI5kefM5i5O
         3jX++BPLDc4S17FV+tmpjtH9YxgdrxXdqBhXkZ8UiQ6/oyHQZLuBNYAW2cBiPUHlbVWV
         6KxpvZL4m2wl7LUTPTfo0bpIi4NRn7ejlyg1EJDEG3GnE6AB958y5fraFlYEKGmYgqpm
         RGoHy4hY1fvCbx6rIKsKE3zEum+kuDeHAl9nurcqrFR08ustf5NSZWwWBqe51NPtkYXO
         yFpA==
X-Gm-Message-State: AOAM531PEbWUPPoQyiZsF/vwDEYhfxHfrOx+5u4Z2PypO7vj0w3Wx5mf
	PEfmJ4hw7sC6/a1IniQU3nc=
X-Google-Smtp-Source: ABdhPJx0BB5CJ8IRPP7wZcpFAKcEtqcXu8b2tEnM5FooOgxWlc7cYpH2HfZCoJcvFlnV/vCsrbagEg==
X-Received: by 2002:a5d:43d2:: with SMTP id v18mr52161392wrr.196.1594116379745;
        Tue, 07 Jul 2020 03:06:19 -0700 (PDT)
Received: from localhost (ip-37-188-179-51.eurotel.cz. [37.188.179.51])
        by smtp.gmail.com with ESMTPSA id d2sm279540wrs.95.2020.07.07.03.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 03:06:18 -0700 (PDT)
Date: Tue, 7 Jul 2020 12:06:17 +0200
From: Michal Hocko <mhocko@kernel.org>
To: Jia He <justin.he@arm.com>
Subject: Re: [PATCH v2 3/3] mm/memory_hotplug: fix unpaired
 mem_hotplug_begin/done
Message-ID: <20200707100617.GD5913@dhcp22.suse.cz>
References: <20200707055917.143653-1-justin.he@arm.com>
 <20200707055917.143653-4-justin.he@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200707055917.143653-4-justin.he@arm.com>
Message-ID-Hash: MDVWTPXZKAYPCGNO4FL2DNETO5N4SEY5
X-Message-ID-Hash: MDVWTPXZKAYPCGNO4FL2DNETO5N4SEY5
X-MailFrom: mstsxfx@gmail.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@linux.ibm.com>, Baoquan He <bhe@redhat.com>, Chuhong Yuan <hslester96@gmail.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, Kaly Xin <Kaly.Xin@arm.com>, stable@vger.kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/MDVWTPXZKAYPCGNO4FL2DNETO5N4SEY5/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue 07-07-20 13:59:17, Jia He wrote:
> When check_memblock_offlined_cb() returns failed rc(e.g. the memblock is
> online at that time), mem_hotplug_begin/done is unpaired in such case.
> 
> Therefore a warning:
>  Call Trace:
>   percpu_up_write+0x33/0x40
>   try_remove_memory+0x66/0x120
>   ? _cond_resched+0x19/0x30
>   remove_memory+0x2b/0x40
>   dev_dax_kmem_remove+0x36/0x72 [kmem]
>   device_release_driver_internal+0xf0/0x1c0
>   device_release_driver+0x12/0x20
>   bus_remove_device+0xe1/0x150
>   device_del+0x17b/0x3e0
>   unregister_dev_dax+0x29/0x60
>   devm_action_release+0x15/0x20
>   release_nodes+0x19a/0x1e0
>   devres_release_all+0x3f/0x50
>   device_release_driver_internal+0x100/0x1c0
>   driver_detach+0x4c/0x8f
>   bus_remove_driver+0x5c/0xd0
>   driver_unregister+0x31/0x50
>   dax_pmem_exit+0x10/0xfe0 [dax_pmem]
> 
> Fixes: f1037ec0cc8a ("mm/memory_hotplug: fix remove_memory() lockdep splat")
> Cc: stable@vger.kernel.org # v5.6+
> Signed-off-by: Jia He <justin.he@arm.com>

Ups, I have missed that when reviewing that commit. Thanks for catching
this up!

Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  mm/memory_hotplug.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index da374cd3d45b..76c75a599da3 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1742,7 +1742,7 @@ static int __ref try_remove_memory(int nid, u64 start, u64 size)
>  	 */
>  	rc = walk_memory_blocks(start, size, NULL, check_memblock_offlined_cb);
>  	if (rc)
> -		goto done;
> +		return rc;
>  
>  	/* remove memmap entry */
>  	firmware_map_remove(start, start + size, "System RAM");
> @@ -1766,9 +1766,8 @@ static int __ref try_remove_memory(int nid, u64 start, u64 size)
>  
>  	try_offline_node(nid);
>  
> -done:
>  	mem_hotplug_done();
> -	return rc;
> +	return 0;
>  }
>  
>  /**
> -- 
> 2.17.1

-- 
Michal Hocko
SUSE Labs
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
