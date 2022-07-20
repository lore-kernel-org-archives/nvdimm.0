Received: from dormouse.elm.relay.mailchannels.net (dormouse.elm.relay.mailchannels.net [23.83.212.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EFEC6ADF
	for <nvdimm@lists.linux.dev>; Wed, 20 Jul 2022 18:26:46 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id A43026C28C1;
	Wed, 20 Jul 2022 18:18:58 +0000 (UTC)
Received: from pdx1-sub0-mail-a292.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id DADB66C15C8;
	Wed, 20 Jul 2022 18:18:57 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1658341138; a=rsa-sha256;
	cv=none;
	b=FA/yYhBqHFz3/jksqVbWQXLopNaOytRNnroM9zaaI7lLTHgGNaVeSxtxN9FWAGo5WTn4lu
	Zuhzi2AIHR09CLZSSnKawPjzG1kF6dORymgp35lpJKPV9u+BK2/NEU2A3T8DB8cSuX+Oh3
	IAhRg/7WeDNCvkAE2ZosRncxXCN3Q8GAJZUraQy98y9OkZ18AZS4CZEdNtF0QkTMdQ0wQp
	kOF72HvLZ7UqgbC10RoveieJkxgK+YoHLOfGgv0IcZApWlnhodKe/TM+Yu9gnZ919k1MOe
	BJrLHtsn2YRaFt1jhWaxz2t6ceqVpnMw5HtjtG4emgshZ+eaI+YUFbozTzMLXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1658341138;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=heo8NSziHONhwwYu9slaF+2VxQH2uPQqFsem70CcVnI=;
	b=2c0aSd80TNsaC258ngjJ0029dMMxCk+UjTvcwCTtMR/ET5U5+S1T4bHZFYCHP2TSMjqrSa
	d4qusOC7sPm6umjUCzNMu8Q1DbNgPe3d2/WAS0pRp31uAtB4CYL1UxDHDsn3/iSjIKcWIU
	TmPkuDn9cyQru2zhcvtNI1s5tczllUpDls+LTZGdyvG9K4itM867284gs7a5uuaSEM+pyG
	3sp0i+lKeXXnaPh+4A9q8+Hhtngho5lBVD05EwQGGdoI3oVKNK12rUSrtm1KFHAnnxr9lf
	iv1RX8/5UShubdJ+WpXrYjnDUIXVueT9qAcDrysR+gvoISE597Uc4zTEAYJvDQ==
ARC-Authentication-Results: i=1;
	rspamd-674ffb986c-hjnl4;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Madly-Zesty: 3d4894d10a7afe77_1658341138268_3260986809
X-MC-Loop-Signature: 1658341138268:3620796171
X-MC-Ingress-Time: 1658341138268
Received: from pdx1-sub0-mail-a292.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.115.18.78 (trex/6.7.1);
	Wed, 20 Jul 2022 18:18:58 +0000
Received: from offworld (unknown [104.36.29.104])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a292.dreamhost.com (Postfix) with ESMTPSA id 4Lp3qh5dPvzHy;
	Wed, 20 Jul 2022 11:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1658341137;
	bh=heo8NSziHONhwwYu9slaF+2VxQH2uPQqFsem70CcVnI=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=ZEopq06f0WzR8C9FbuZm0K9he2VF+N/kQQwi541gcQ00xXWR/vlhsI3jYpzJYMkUB
	 apDGL4q14kWbSRmSy6Fx2mox+E3rHp8X+bT2qmUtQpfdbK9khTiwJ+CeOlURRP1SG3
	 w2gHaYYRkKr1DIa4G1/EU1f6TrYmqNA3PYhI0oXK5O6z2solLZccL3S8nP2ngvQUW8
	 cMVYasTBNJcsJribu2J85JoBPHQX95rY6Rf/eN8DwWUXOnE/2J/xuBkVKG1Crw236K
	 M496bBFXALN4834I1d4uzgkqKxFELO+efhiabwtK9HWEspK3NJFB1E/1cxiQmfobYg
	 jwCbrZRGJ3Glg==
Date: Wed, 20 Jul 2022 11:02:47 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	dan.j.williams@intel.com, bwidawsk@kernel.org, ira.weiny@intel.com,
	vishal.l.verma@intel.com, alison.schofield@intel.com,
	a.manzanares@samsung.com
Subject: Re: [PATCH RFC 13/15] cxl/pmem: Add "Passphrase Secure Erase"
 security command support
Message-ID: <20220720180247.z4i3yzdicnnsissz@offworld>
References: <165791918718.2491387.4203738301057301285.stgit@djiang5-desk3.ch.intel.com>
 <165791938847.2491387.8701829648751368015.stgit@djiang5-desk3.ch.intel.com>
 <20220720061727.ufygesevkonmeelr@offworld>
 <d595bc58-7305-7f27-4ec0-218eb6492fd3@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <d595bc58-7305-7f27-4ec0-218eb6492fd3@intel.com>
User-Agent: NeoMutt/20220429

On Wed, 20 Jul 2022, Dave Jiang wrote:

>Patch below is about what I had in mind for the secure erase command.
>Looks good to me. The only thing I think it needs is to make sure the
>mem devs are not "in use" before secure erase in addition to the
>security check that's already there below. I was planning on working
>on this after getting the current security commands series wrapped up.
>But if you are already developing this then I'll defer.
>
>Also here's the latest code that I'm still going through testing if
>you want to play with it. I still need to replace the x86 patch with
>your version.

Ok I will play more and test your series during the rest of the week,
as well as my own changes. I'll end up a formal series on top of this
one (or whatever version you are at at the time) with the sanitize
+ secure-erase (and the relevant mock device updates).

Thanks,
Davidlohr
