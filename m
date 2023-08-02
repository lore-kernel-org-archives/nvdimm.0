Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FA879FF
	for <nvdimm@lists.linux.dev>; Wed,  2 Aug 2023 15:36:35 +0000 (UTC)
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-790af3bfa5cso35237839f.1
        for <nvdimm@lists.linux.dev>; Wed, 02 Aug 2023 08:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690990594; x=1691595394;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=673FNT9+5mnaLVg5PRS120UPJdmtYWKDCkh6MjsqAGk=;
        b=R4amrDn6vllXAmBsGQnv9oHwNxdRbsqsTtZSo7STLE0X4xCcT2NH/8UwHo1w3NE7X9
         yLybNlu8wgc7zT+0qwXccOSODFeIOgs9wa1sY9SzjmfxegGbJreQCHQtUdQv+n3auNUS
         0LHE53TlHXsqs9NO32h18jJeakxACNmc/nwB0Q27z1rgXh2qGIjMZcv+4YTcZ74DPc0g
         vKos/2ByJZx1J4oBOK2OJ2b6JtmqCsspCzSwcI8OSlGURpj0+hMyhHREQ6/P0ujI9eKK
         tMtjUzcu5P54T2iMMxojTWO//ZVjDzPDWhHmhPBIsYvOkYh2mSxgIweS8G5VtMk5FFpG
         tEkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690990594; x=1691595394;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=673FNT9+5mnaLVg5PRS120UPJdmtYWKDCkh6MjsqAGk=;
        b=Mknil4tUHcW4AMe+fsOtCQ7T0i3BJ5o296vpf+uHFu5eVtBOxHk7v2MjF/zSbCkDK5
         iLqWqVvmd/A/ePnFLwUXPvOwooqbYa0oIwvTFbMYstv9HWHYP9kt0GFCwg8nH2/knSiO
         qhSW3TgWhFtHmhe9/uPAQaTLa3HnYQ1MhyLCXYcfmeraIaf9cWprKbTxgZHjt1CUnB1d
         ovS0bKBFH7ZUX7VjQacipfc9ss5L7T/Mdq7VyoidfRr1Wx1DftArzAmCDnAfFy9V7l7d
         2dGfSN5jjeIP3lWLZ2mVyyJEZRA19YrKIHHBXM+1Jb1fa+9xTsZZyml3sWeXTTz900Is
         eCRw==
X-Gm-Message-State: ABy/qLYea7h4rmoiujeCspaqmgU599pEvG9wCJ7Ag/2IEF34QoB9CN9P
	UgQnwQYNgwFCHieueEtBpIT8knVW2vK2oPp+GuU=
X-Google-Smtp-Source: APBJJlGUkAAAMCsRyqhq/PIoWTsQaXC7gGA1eoObLajsTDL34SrB7j0y4Xe/8ukTb5Tru29rdlT26A==
X-Received: by 2002:a05:6602:2b91:b0:77a:ee79:652 with SMTP id r17-20020a0566022b9100b0077aee790652mr18610565iov.1.1690990594272;
        Wed, 02 Aug 2023 08:36:34 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id m18-20020a056638225200b0042b08954dc3sm4351434jas.33.2023.08.02.08.36.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Aug 2023 08:36:33 -0700 (PDT)
Message-ID: <17c5d907-d276-bffc-17ca-d796156a2b78@kernel.dk>
Date: Wed, 2 Aug 2023 09:36:32 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: [PATCH V2 1/1] pmem: set QUEUE_FLAG_NOWAIT
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc: Jeff Moyer <jmoyer@redhat.com>,
 "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
 "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
 "dave.jiang@intel.com" <dave.jiang@intel.com>,
 "ira.weiny@intel.com" <ira.weiny@intel.com>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 linux-block@vger.kernel.org
References: <20230731224617.8665-1-kch@nvidia.com>
 <20230731224617.8665-2-kch@nvidia.com>
 <x491qgmwzuv.fsf@segfault.boston.devel.redhat.com>
 <20230801155943.GA13111@lst.de>
 <x49wmyevej2.fsf@segfault.boston.devel.redhat.com>
 <0a2d86d6-34a1-0c8d-389c-1dc2f886f108@nvidia.com>
 <20230802123010.GB30792@lst.de>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230802123010.GB30792@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/2/23 6:30?AM, Christoph Hellwig wrote:
> Given that pmem simply loops over an arbitrarily large bio I think
> we also need a threshold for which to allow nowait I/O.  While it
> won't block for giant I/Os, doing all of them in the submitter
> context isn't exactly the idea behind the nowait I/O.

You can do a LOT of looping over a giant bio and still come out way
ahead compared to needing to punt to a different thread. So I do think
it's the right choice. But I'm making assumptions here on what it looks
like, as I haven't seen the patch...

> Btw, please also always add linux-block to the Cc list for block
> driver patches that are even the slightest bit about the block
> layer interface.

Indeed. Particularly for these nowait changes, as some of them have been
pretty broken in the past.

-- 
Jens Axboe

