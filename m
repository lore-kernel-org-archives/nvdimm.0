Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4062FB0
	for <nvdimm@lists.linux.dev>; Tue, 20 Jul 2021 09:52:37 +0000 (UTC)
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0B1DF1FD3E;
	Tue, 20 Jul 2021 09:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1626774756; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0S3FE71qGo66t31Vxc28Wi9V+Ayx6OZMuHotTPZ+18Y=;
	b=c2XzEflSX0tIvkoXclpsr1Pe1rwb9SiwUw5Glll8ctmd9TDuRsQwYS1BLW/AjVcFtvH+Rq
	W6oJgU04IUmXu1L/1wUNyWdN6bOMgy+b6ADzKJW1x0BccrffxjZDSzIduLav2BcOc6NBmk
	IKBPPCIKUYUO4NmItmpCSt/z+J74vDI=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 80D2213AA2;
	Tue, 20 Jul 2021 09:52:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap1.suse-dmz.suse.de with ESMTPSA
	id +x0ZHeOc9mCHKgAAGKfGzw
	(envelope-from <nborisov@suse.com>); Tue, 20 Jul 2021 09:52:35 +0000
Subject: Re: [PATCH 03/27] iomap: mark the iomap argument to iomap_sector
 const
To: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
 Matthew Wilcox <willy@infradead.org>,
 Andreas Gruenbacher <agruenba@redhat.com>,
 Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
 nvdimm@lists.linux.dev, cluster-devel@redhat.com
References: <20210719103520.495450-1-hch@lst.de>
 <20210719103520.495450-4-hch@lst.de> <20210719160820.GE22402@magnolia>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <ab10035a-43ee-8f25-47c0-57321f748abd@suse.com>
Date: Tue, 20 Jul 2021 12:52:35 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20210719160820.GE22402@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit



On 19.07.21 г. 19:08, Darrick J. Wong wrote:
> On Mon, Jul 19, 2021 at 12:34:56PM +0200, Christoph Hellwig wrote:
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> /me wonders, does this have any significant effect on the generated
> code?

https://theartofmachinery.com/2019/08/12/c_const_isnt_for_performance.html

> 
> It's probably a good idea to feed the optimizer as much usage info as we
> can, though I would imagine that for such a simple function it can
> probably tell that we don't change *iomap.
> 
> IMHO, constifiying functions is a good way to signal to /programmers/
> that they're not intended to touch the arguments, so
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> --D
> 
>> ---
>>  include/linux/iomap.h | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
>> index 093519d91cc9cc..f9c36df6a3061b 100644
>> --- a/include/linux/iomap.h
>> +++ b/include/linux/iomap.h
>> @@ -91,8 +91,7 @@ struct iomap {
>>  	const struct iomap_page_ops *page_ops;
>>  };
>>  
>> -static inline sector_t
>> -iomap_sector(struct iomap *iomap, loff_t pos)
>> +static inline sector_t iomap_sector(const struct iomap *iomap, loff_t pos)
>>  {
>>  	return (iomap->addr + pos - iomap->offset) >> SECTOR_SHIFT;
>>  }
>> -- 
>> 2.30.2
>>
> 
