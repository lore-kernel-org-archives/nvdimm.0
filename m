Received: from out199-6.us.a.mail.aliyun.com (out199-6.us.a.mail.aliyun.com [47.90.199.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3A117735
	for <nvdimm@lists.linux.dev>; Tue, 12 Dec 2023 07:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0VyLlE91_1702367425;
Received: from 30.97.49.22(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0VyLlE91_1702367425)
          by smtp.aliyun-inc.com;
          Tue, 12 Dec 2023 15:50:27 +0800
Message-ID: <58d175f8-a06e-4b00-95fe-1bd5a79106df@linux.alibaba.com>
Date: Tue, 12 Dec 2023 15:50:25 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC KERNEL] initoverlayfs - a scalable initial filesystem
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Curtin <ecurtin@redhat.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 linux-unionfs@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 Daan De Meyer <daan.j.demeyer@gmail.com>,
 Stephen Smoogen <ssmoogen@redhat.com>, Yariv Rachmani <yrachman@redhat.com>,
 Daniel Walsh <dwalsh@redhat.com>, Douglas Landgraf <dlandgra@redhat.com>,
 Alexander Larsson <alexl@redhat.com>, Colin Walters <walters@redhat.com>,
 Brian Masney <bmasney@redhat.com>, Eric Chanudet <echanude@redhat.com>,
 Pavol Brilla <pbrilla@redhat.com>, Lokesh Mandvekar <lmandvek@redhat.com>,
 =?UTF-8?Q?Petr_=C5=A0abata?= <psabata@redhat.com>,
 Lennart Poettering <lennart@poettering.net>, Luca Boccassi
 <bluca@debian.org>, Neal Gompa <neal@gompa.dev>, nvdimm@lists.linux.dev
References: <CAOgh=Fwb+JCTQ-iqzjq8st9qbvauxc4gqqafjWG2Xc08MeBabQ@mail.gmail.com>
 <941aff31-6aa4-4c37-bb94-547c46250304@linux.alibaba.com>
 <ZXgNQ85PdUKrQU1j@infradead.org>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <ZXgNQ85PdUKrQU1j@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2023/12/12 15:35, Christoph Hellwig wrote:
> On Tue, Dec 12, 2023 at 08:50:56AM +0800, Gao Xiang wrote:
>> For non-virtualization cases, I guess you could try to use `memmap`
>> kernel option [2] to specify a memory region by bootloaders which
>> contains an EROFS rootfs and a customized init for booting as
>> erofs+overlayfs at least for `initoverlayfs`.  The main benefit is
>> that the memory region specified by the bootloader can be directly
>> used for mounting.  But I never tried if this option actually works.
>>
>> Furthermore, compared to traditional ramdisks, using direct address
>> can avoid page cache totally for uncompressed files like it can
>> just use unencoded data as mmaped memory.  For compressed files, it
>> still needs page cache to support mmaped access but we could adapt
>> more for persistent memory scenarios such as disable cache
>> decompression compared to previous block devices.
>>
>> I'm not sure if it's worth implementing this in kernelspace since
>> it's out of scope of an individual filesystem anyway.
> 
> IFF the use case turns out to be generally useful (it looks quite
> convoluted and odd to me), we could esily do an initdax concept where
> a chunk of memory passed by the bootloader is presented as a DAX device
> properly without memmap hacks.

I have no idea how it's faster than the current initramfs or initrd.
So if it's really useful, maybe some numbers can be posted first
with the current `memmap` hack and see it's worth going further with
some new infrastructure like initdax.

Thanks,
Gao Xiang


