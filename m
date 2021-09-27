Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3CC3FD6
	for <nvdimm@lists.linux.dev>; Mon, 27 Sep 2021 22:33:39 +0000 (UTC)
Received: by mail-il1-f182.google.com with SMTP id h20so21005480ilj.13
        for <nvdimm@lists.linux.dev>; Mon, 27 Sep 2021 15:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LOsuwHDiPC+PPoCEQN/qtQeyMVFZbR3g1AzPIbWGz1s=;
        b=YTqmdXk5vu2O6Z09DphFzhzdWxPQ8jmaJFHrIsMI+6Jhr8dovpFIgf0hfWsFZmWJGq
         EVBCGkS1YFFNZ8M01WgONYjDBxGTGP/DCZWSKVCmRzFam2Hh4IgqxVmjePf268PGtV81
         f5vMDXMmwBYUfauwYcel2Rv7+Z/vgk39qzYsRkTAosBsqgB4GwDsvm6cOxLKEb7WhBzu
         TSGL2cQt0huoDrGurVnZof3FIGpxyaHR8+jLKBQHjcW0vLlSgpEdy3xv/8pfNM0RjCzL
         S68pit92xtiJTYJshqe0ROVs/67npCPOQRoa5DA5iXWksCwd+SjdXeI2A9yZ8hXhKis6
         coXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LOsuwHDiPC+PPoCEQN/qtQeyMVFZbR3g1AzPIbWGz1s=;
        b=AFonYshYyfHCrfR+iQ3QcphJpjEtiPWByYIPO/mJ3jx+jn7SGnolVXNGuoZjYSDLD3
         jOvNVS1nXsMWK1VY8PxwQqQ/V5zrDyJyXNRZJXa/XO1oK7zt5FGpGAWUwCZ0T/S7CVuf
         9nyJoFrh/uqqu++NTgcua0+GEYODeOeAAqTG/cWN2OWGohOLnvLwAAepOR73OjFnqeZQ
         KiugeJ2Iem0EWaSyxH9f5pMQsMdX2smtxYE5YqNs2rhJOiSBQNd0CuUtBCcuVk0/GnH8
         uZpmdzjSGYiWZXJDnsAMUR3u/+be74gu1jh589qxZNL1/Sirtblk139xYVF1ZhEvjfAs
         cubQ==
X-Gm-Message-State: AOAM532l7zRmM48YxFT7Szq9rEgCQGzg8xdlCZEIg0R8FffDlf87+NHu
	kZh3f9AURE/7yn3md2EYIti83g==
X-Google-Smtp-Source: ABdhPJwueWxtKqjP8KyNWWEV43ZHbAJgLgbtzL1ErWyEowm3/77Murhw193eceS6jFlQ9sjaEQjTVg==
X-Received: by 2002:a92:da85:: with SMTP id u5mr1851944iln.213.1632782018707;
        Mon, 27 Sep 2021 15:33:38 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id y2sm6427866iot.45.2021.09.27.15.33.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 15:33:38 -0700 (PDT)
Subject: Re: [PATCH v2 00/10] block: second batch of add_disk() error handling
 conversions
To: Luis Chamberlain <mcgrof@kernel.org>, colyli@suse.de,
 kent.overstreet@gmail.com, kbusch@kernel.org, sagi@grimberg.me,
 vishal.l.verma@intel.com, dan.j.williams@intel.com, dave.jiang@intel.com,
 ira.weiny@intel.com, konrad.wilk@oracle.com, roger.pau@citrix.com,
 boris.ostrovsky@oracle.com, jgross@suse.com, sstabellini@kernel.org,
 minchan@kernel.org, ngupta@vflare.org, senozhatsky@chromium.org
Cc: xen-devel@lists.xenproject.org, nvdimm@lists.linux.dev,
 linux-nvme@lists.infradead.org, linux-bcache@vger.kernel.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210927220039.1064193-1-mcgrof@kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <c17004ed-884f-5a97-c333-602e3f9903e7@kernel.dk>
Date: Mon, 27 Sep 2021 16:33:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20210927220039.1064193-1-mcgrof@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 9/27/21 4:00 PM, Luis Chamberlain wrote:
> This is the second series of driver conversions for add_disk()
> error handling. You can find this set and the rest of the 7th set of
> driver conversions on my 20210927-for-axboe-add-disk-error-handling
> branch [0].

Applied 1, thanks.

-- 
Jens Axboe

