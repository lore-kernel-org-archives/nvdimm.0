Return-Path: <SRS0=oW+C=6A=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A710BC2BA2B
	for <linux-nvdimm@archiver.kernel.org>; Thu, 16 Apr 2020 06:20:02 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 83AB02078A
	for <linux-nvdimm@archiver.kernel.org>; Thu, 16 Apr 2020 06:20:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 83AB02078A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id D301C10FC377C;
	Wed, 15 Apr 2020 23:20:26 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=209.85.221.67; helo=mail-wr1-f67.google.com; envelope-from=mstsxfx@gmail.com; receiver=<UNKNOWN> 
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com [209.85.221.67])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id CBBCA1010633F
	for <linux-nvdimm@lists.01.org>; Wed, 15 Apr 2020 23:19:35 -0700 (PDT)
Received: by mail-wr1-f67.google.com with SMTP id d17so3352867wrg.11
        for <linux-nvdimm@lists.01.org>; Wed, 15 Apr 2020 23:19:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=haajFqWOpRJreRTyzwRLBENBKY1jRYi5OSxNLILpaiI=;
        b=GLSfOmwah45EJAp4Yib053vLFt+HHI8cqkAyPk6YdxeXkqDXvIyk20g5qeBNTMKlHZ
         /BjgxfAaTN6ohPSwqZJH7AzVOWqzkM6zzmWp0Tbe82Hfbg9VKMs+imrjSZiCdal+8gV3
         Uyo+iKHbJHFNqVCUSwYq3/4OlIjZ7oW4Y4cKqmEgjTdla0NnIWss8YxdXUoYARNI2S1n
         AtftlKalbL461O/lPobTXQ0btcbbeQbOlany+Xog0ZB6QRuKyrN8c2oqCQKUsdVjGGWC
         0R9WoSFwYZJy+DhQ96Pt2qyF9WPBV64PljipMdP8k14d0l2quIm5UTQOE8gY04SFYYyA
         qtTQ==
X-Gm-Message-State: AGi0PuYpCHcfDRwQhr80uwg4+tcoSLuWqjk5v/WNHHTQB8DHz7o3p1vB
	Ham8LZOnNKfD80tH76vz02o=
X-Google-Smtp-Source: APiQypKkZMIkiyYBgrloelSVESTBcV5kX27Ao3yrPl5Q1JjY/dcsEUmpckaldqLO+JBqYK8nwo6msA==
X-Received: by 2002:a5d:4005:: with SMTP id n5mr7646223wrp.242.1587017949484;
        Wed, 15 Apr 2020 23:19:09 -0700 (PDT)
Received: from localhost (ip-37-188-180-223.eurotel.cz. [37.188.180.223])
        by smtp.gmail.com with ESMTPSA id j11sm4777116wrr.62.2020.04.15.23.19.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2020 23:19:08 -0700 (PDT)
Date: Thu, 16 Apr 2020 08:19:07 +0200
From: Michal Hocko <mhocko@kernel.org>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v3] mm/memory_hotplug: refrain from adding memory into an
 impossible node
Message-ID: <20200416061907.GA26707@dhcp22.suse.cz>
References: <20200414235812.6158-1-vishal.l.verma@intel.com>
 <20200415104338.GF4629@dhcp22.suse.cz>
 <7a37b7c03e983ceb32337325fa2a724fa614607b.camel@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <7a37b7c03e983ceb32337325fa2a724fa614607b.camel@intel.com>
Message-ID-Hash: 5G6XXB5656ARDPA3ZC47ON4GWHMXBGRK
X-Message-ID-Hash: 5G6XXB5656ARDPA3ZC47ON4GWHMXBGRK
X-MailFrom: mstsxfx@gmail.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "david@redhat.com" <david@redhat.com>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/5G6XXB5656ARDPA3ZC47ON4GWHMXBGRK/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed 15-04-20 20:32:00, Verma, Vishal L wrote:
> On Wed, 2020-04-15 at 12:43 +0200, Michal Hocko wrote:
> > On Tue 14-04-20 17:58:12, Vishal Verma wrote:
> > [...]
> > > +static int check_hotplug_node(int nid)
> > > +{
> > > +	int alt_nid;
> > > +
> > > +	if (node_possible(nid))
> > > +		return nid;
> > > +
> > > +	alt_nid = numa_map_to_online_node(nid);
> > > +	if (alt_nid == NUMA_NO_NODE)
> > > +		alt_nid = first_online_node;
> > > +	WARN_TAINT(1, TAINT_FIRMWARE_WORKAROUND,
> > > +		   "node %d expected, but was absent from the node_possible_map, using %d instead\n",
> > > +		   nid, alt_nid);
> > 
> > I really do not like this. Why should we try to be clever and change the
> > node id requested by the caller? I would just stick with node_possible
> > check and be done with this.
> 
> Hi Michal,
> 
> Being clever allows us to still use the memory even if it is in a non-
> optimal configuration. Failing here leaves the user no path to add this
> memory until the firmware is fixed. It is the tradeoff between some
> usability vs. how loud we want to be for the failure.

Doing that papers over something that is clearly a FW issue and makes
it "my performance is suboptimal" deal with it OS problem.  Really, is
this something we have to care about. Your changelog talks about a Qemu
misconfiguration which is trivial to fix. Has this ever been observed
with a real HW?

-- 
Michal Hocko
SUSE Labs
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
