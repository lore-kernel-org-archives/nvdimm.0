Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B653672
	for <nvdimm@lists.linux.dev>; Thu, 23 Sep 2021 07:14:04 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C012920278;
	Thu, 23 Sep 2021 07:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1632381236; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QY7WPyKmhlWy7yhhaiksEFQ2o0DzPZj/w9H1QqhuKSk=;
	b=TCLmHYAUJbBa25xCbUStdXDCFQLpDhOEySKAa0C/wKkmvol8THH6kNOvtm4kXMH2E3J8+j
	9AaGqDrqopZEGzTtsTCutCElnq2ezUVRgEgXXLLoMJDit+V7v9aOmo/N9RIQPX7fC9ld6r
	lVSSHmNLSAsoYl4PZGAWTZG1dn0FGA0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1632381236;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QY7WPyKmhlWy7yhhaiksEFQ2o0DzPZj/w9H1QqhuKSk=;
	b=dUbcrPlGddRby7zrgkcuSNqKrOPPR66Anzv6Ad3RLQpBeQLL2CDO2cwrtPkPWXYrEfiH9u
	eg7ZCDqHtS3Vz+Ag==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 61C5C13DC4;
	Thu, 23 Sep 2021 07:13:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id u+DLDTIpTGHcdAAAMHmgww
	(envelope-from <colyli@suse.de>); Thu, 23 Sep 2021 07:13:54 +0000
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
 <e227eb59-fcda-8f3e-d305-b4c21f0f2ef2@suse.de> <YUwjAJXjFR9tbJiQ@kroah.com>
From: Coly Li <colyli@suse.de>
Message-ID: <0a9f7fd9-a587-0152-118f-c61fe563f97f@suse.de>
Date: Thu, 23 Sep 2021 15:13:52 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <YUwjAJXjFR9tbJiQ@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US

On 9/23/21 2:47 PM, Greg Kroah-Hartman wrote:
> On Thu, Sep 23, 2021 at 02:14:12PM +0800, Coly Li wrote:
>> On 9/23/21 2:08 PM, Greg Kroah-Hartman wrote:
>>> On Thu, Sep 23, 2021 at 01:59:28PM +0800, Coly Li wrote:
>>>> Hi all the kernel gurus, and folks in mailing lists,
>>>>
>>>> This is a question about exporting 4KB+ text information via sysfs
>>>> interface. I need advice on how to handle the problem.
>> Hi Greg,
>>
>> This is the code in mainline kernel for quite long time.
> {sigh}
>
> What tools rely on this?  If none, just don't add new stuff to the file
> and work to create a new api instead.

At least I know mdadm uses this sysfs interface for md raid component 
disks monitoring. It has been in mdadm for around 5 years.

Yes you are right, let it be for existing sysfs interface to avoid 
breaking things.

>>> Please do not do that.  Seriously, that is not what sysfs is for, and is
>>> an abuse of it.
>>>
>>> sysfs is for "one value per file" and should never even get close to a
>>> 4kb limit.  If it does, you are doing something really really wrong and
>>> should just remove that sysfs file from the system and redesign your
>>> api.
>> I understand this. And what I addressed is the problem I need to fix.
>>
>> The code is there for almost 10 years, I just find it during my work on bad
>> blocks API fixing.
>>
>>
>>>> Recently I work on the bad blocks API (block/badblocks.c) improvement, there
>>>> is a sysfs file to export the bad block ranges for me raid. E.g for a md
>>>> raid1 device, file
>>>>       /sys/block/md0/md/rd0/bad_blocks
>>>> may contain the following text content,
>>>>       64 32
>>>>      128 8
>>> Ick, again, that's not ok at all.  sysfs files should never have to be
>>> parsed like this.
>> I cannot agree more with you. What I am asking for was ---- how to fix it ?
> Best solution, come up with a new api.
>
> Worst solution, you are stuck with the existing file and I can show you
> the "way out" of dealing with files larger than 4kb in sysfs that a
> number of other apis are being forced to do as they grow over time.

Now I am sure you are very probably not willing to accept the patches, 
even I know how to do that :-)

>
> But ideally, just drop ths api and make a new one please.

OK, then I leave the existing things as what they are, avoid to make 
them worse.

Thanks for your response.

Coly Li

