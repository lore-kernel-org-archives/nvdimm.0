Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E603FC7
	for <nvdimm@lists.linux.dev>; Thu, 23 Sep 2021 06:14:18 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7847622326;
	Thu, 23 Sep 2021 06:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1632377657; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o0l2RHdc1VTxle7geiUN7AAnIlMhU8AgWvN0GgDIMdE=;
	b=HyEJd+cNPg3rUBdiB/5jTWFbun2xaZfnqW48HD5bLI2EDmo3D1lUUxrT0tc1cttoXdoWE+
	D8HhDttgCm7dq1M/s54x7rWMb2GW5A2v93X0T8Frhn6nF1aVCyOTWArX2uMQzg2XLDaBNw
	dumzyXgB5rztuWMH6KIJx56EjmGqaIw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1632377657;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o0l2RHdc1VTxle7geiUN7AAnIlMhU8AgWvN0GgDIMdE=;
	b=9bE/juPlOpYXf9idmLGTvOH4t7+Ic5QXdOBeROUigVxpY5/fkyZIOLBdQbEhf8otiBRvvm
	yhVIAyyCvfuU6TDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5804B13DB5;
	Thu, 23 Sep 2021 06:14:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 1T2PCTYbTGFlWAAAMHmgww
	(envelope-from <colyli@suse.de>); Thu, 23 Sep 2021 06:14:14 +0000
Subject: Re: Too large badblocks sysfs file (was: [PATCH v3 0/7] badblocks
 improvement for multiple bad block ranges)
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
 antlists@youngman.org.uk, Dan Williams <dan.j.williams@intel.com>,
 Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
 NeilBrown <neilb@suse.de>, Richard Fan <richard.fan@suse.com>,
 Vishal L Verma <vishal.l.verma@intel.com>, rafael@kernel.org
References: <20210913163643.10233-1-colyli@suse.de>
 <a0f7b021-4816-6785-a9a4-507464b55895@suse.de> <YUwZ95Z+L5M3aZ9V@kroah.com>
From: Coly Li <colyli@suse.de>
Message-ID: <e227eb59-fcda-8f3e-d305-b4c21f0f2ef2@suse.de>
Date: Thu, 23 Sep 2021 14:14:12 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <YUwZ95Z+L5M3aZ9V@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US

On 9/23/21 2:08 PM, Greg Kroah-Hartman wrote:
> On Thu, Sep 23, 2021 at 01:59:28PM +0800, Coly Li wrote:
>> Hi all the kernel gurus, and folks in mailing lists,
>>
>> This is a question about exporting 4KB+ text information via sysfs
>> interface. I need advice on how to handle the problem.

Hi Greg,

This is the code in mainline kernel for quite long time.

> Please do not do that.  Seriously, that is not what sysfs is for, and is
> an abuse of it.
>
> sysfs is for "one value per file" and should never even get close to a
> 4kb limit.  If it does, you are doing something really really wrong and
> should just remove that sysfs file from the system and redesign your
> api.

I understand this. And what I addressed is the problem I need to fix.

The code is there for almost 10 years, I just find it during my work on 
bad blocks API fixing.


>
>> Recently I work on the bad blocks API (block/badblocks.c) improvement, there
>> is a sysfs file to export the bad block ranges for me raid. E.g for a md
>> raid1 device, file
>>      /sys/block/md0/md/rd0/bad_blocks
>> may contain the following text content,
>>      64 32
>>     128 8
> Ick, again, that's not ok at all.  sysfs files should never have to be
> parsed like this.

I cannot agree more with you. What I am asking for was ---- how to fix it ?

Thanks.

Coly Li

