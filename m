Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D0F29CA
	for <nvdimm@lists.linux.dev>; Mon, 27 Sep 2021 07:24:03 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id t9so3074779pju.5
        for <nvdimm@lists.linux.dev>; Mon, 27 Sep 2021 00:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=zRcqo9ZRM0x4X1qC1VhpLMYfBLcHfFC5rDADl7ze48U=;
        b=bOT9MpcfrFqg+qIyclqxXB8nUB7bsphZ1S/xpNatC4515Qo0sU2pi7x/EqYfPeIecW
         mlWgsxwLB5US417ZTRVOTKD08cp+ghdFf4H9oqoHaxWhlzirb3f2FWOuxybhJkvZ/+ja
         qKOa4lVx0cxzVRr3tICl9/dqMwoYYiDuILPunoXKMJ988zvC3pkXz84SY02xR91xqMeK
         Mhp2uzUyyW2uZ/0Nc8HRp7/1fexH3wr5WeeDqSNePU1G8UM800sMYpIUEBhhJ1q8EClr
         3QGi9A8k5/PF2XUlSqn4bI8rhW3d22Oma7WyaTjuyEkKGu9oyDLD/vKogouMl84vHBQO
         3QhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zRcqo9ZRM0x4X1qC1VhpLMYfBLcHfFC5rDADl7ze48U=;
        b=6YW889yKxzJQuGmk8O8S0Edx/dnlRUyJigUhgbe9m73WGiUTa7fWEDFLtGd6atOOAX
         PeHLaUJN9Qejpw7alXQIgx2qnegb2eRBNGYsHmhm5hnHFekBaRboU+5rEXkU2Iq56Rkn
         0O6gG9VnIC+PICtibMe3S1/NoKExVC1JY51k9okWgPFulB2wCb+Yl9OOk9N4WaATW4/7
         GExnONB6UppIoe97zvfiT+zR8/+/GrTWe7RdpqzFD++qlN+yLRvQg36SrULmyQm/yxN/
         s8cKSNJp6se4XYJokhBYIL75yzQlqTBwbfPp6okkKLftzPCd5l/O/oC6qQ7adtadHmNq
         OXbQ==
X-Gm-Message-State: AOAM5316S4AlbK+/lbK8SyKBmOAGT13rzG5zGsvfdlET6AHQj6Yi6Lic
	PYEVEP9cOxXfGli9LmOJtiI=
X-Google-Smtp-Source: ABdhPJyM/wgKmx+FlPefYMinMxbqa/qTjV2GwDFj7rJrusdlBfsgZsLqa6sHI/ycfYifxKX04bR5Fg==
X-Received: by 2002:a17:90a:bc8d:: with SMTP id x13mr18015275pjr.9.1632727442789;
        Mon, 27 Sep 2021 00:24:02 -0700 (PDT)
Received: from [10.239.207.187] ([43.224.245.179])
        by smtp.gmail.com with ESMTPSA id q16sm14532927pfh.16.2021.09.27.00.23.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 00:24:02 -0700 (PDT)
Message-ID: <e0fc4902-e8db-b507-651b-d930a74702ef@gmail.com>
Date: Mon, 27 Sep 2021 15:23:57 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 1/6] badblocks: add more helper structure and routines
 in badblocks.h
Content-Language: en-US
To: Coly Li <colyli@suse.de>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
 nvdimm@lists.linux.dev
Cc: antlists@youngman.org.uk, Dan Williams <dan.j.williams@intel.com>,
 Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
 NeilBrown <neilb@suse.de>, Richard Fan <richard.fan@suse.com>,
 Vishal L Verma <vishal.l.verma@intel.com>
References: <20210913163643.10233-1-colyli@suse.de>
 <20210913163643.10233-2-colyli@suse.de>
From: Geliang Tang <geliangtang@gmail.com>
In-Reply-To: <20210913163643.10233-2-colyli@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Coly,

On 9/14/21 00:36, Coly Li wrote:
> This patch adds the following helper structure and routines into
> badblocks.h,
> - struct badblocks_context
>    This structure is used in improved badblocks code for bad table
>    iteration.
> - BB_END()
>    The macro to culculate end LBA of a bad range record from bad
>    table.
> - badblocks_full() and badblocks_empty()
>    The inline routines to check whether bad table is full or empty.
> - set_changed() and clear_changed()
>    The inline routines to set and clear 'changed' tag from struct
>    badblocks.
> 
> These new helper structure and routines can help to make the code more
> clear, they will be used in the improved badblocks code in following
> patches.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: NeilBrown <neilb@suse.de>
> Cc: Richard Fan <richard.fan@suse.com>
> Cc: Vishal L Verma <vishal.l.verma@intel.com>
> ---
>   include/linux/badblocks.h | 32 ++++++++++++++++++++++++++++++++
>   1 file changed, 32 insertions(+)
> 
> diff --git a/include/linux/badblocks.h b/include/linux/badblocks.h
> index 2426276b9bd3..166161842d1f 100644
> --- a/include/linux/badblocks.h
> +++ b/include/linux/badblocks.h
> @@ -15,6 +15,7 @@
>   #define BB_OFFSET(x)	(((x) & BB_OFFSET_MASK) >> 9)
>   #define BB_LEN(x)	(((x) & BB_LEN_MASK) + 1)
>   #define BB_ACK(x)	(!!((x) & BB_ACK_MASK))
> +#define BB_END(x)	(BB_OFFSET(x) + BB_LEN(x))
>   #define BB_MAKE(a, l, ack) (((a)<<9) | ((l)-1) | ((u64)(!!(ack)) << 63))
>   
>   /* Bad block numbers are stored sorted in a single page.
> @@ -41,6 +42,14 @@ struct badblocks {
>   	sector_t size;		/* in sectors */
>   };
>   
> +struct badblocks_context {
> +	sector_t	start;
> +	sector_t	len;

I think the type of 'len' should be 'int' instead of 'sector_t', since 
we used 'int sectors' as one of the arguments of _badblocks_set().

> +	int		ack;
> +	sector_t	orig_start;
> +	sector_t	orig_len;

I think 'orig_start' and 'orig_len' can be dropped, see comments in patch 3.

> +};
> +
>   int badblocks_check(struct badblocks *bb, sector_t s, int sectors,
>   		   sector_t *first_bad, int *bad_sectors);
>   int badblocks_set(struct badblocks *bb, sector_t s, int sectors,
> @@ -63,4 +72,27 @@ static inline void devm_exit_badblocks(struct device *dev, struct badblocks *bb)
>   	}
>   	badblocks_exit(bb);
>   }
> +
> +static inline int badblocks_full(struct badblocks *bb)
> +{
> +	return (bb->count >= MAX_BADBLOCKS);
> +}
> +
> +static inline int badblocks_empty(struct badblocks *bb)
> +{
> +	return (bb->count == 0);
> +}
> +
> +static inline void set_changed(struct badblocks *bb)
> +{
> +	if (bb->changed != 1)
> +		bb->changed = 1;
> +}
> +
> +static inline void clear_changed(struct badblocks *bb)
> +{
> +	if (bb->changed != 0)
> +		bb->changed = 0;
> +}
> +
>   #endif
> 

