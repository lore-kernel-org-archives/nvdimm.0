Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29271160
	for <nvdimm@lists.linux.dev>; Mon, 27 Feb 2023 00:08:02 +0000 (UTC)
Received: by mail-pj1-f44.google.com with SMTP id 6-20020a17090a190600b00237c5b6ecd7so3863314pjg.4
        for <nvdimm@lists.linux.dev>; Sun, 26 Feb 2023 16:08:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2MTXMIlz/dV0iBnAtnBofs7P8vQ/S8XF/YLaf2+qt2M=;
        b=d+9lTc6+OUhmOYiqKJRCk50VavmXC3N+7KWcPckDoUDZ7l9ArueFObChf7lgiN4W3O
         rDBuiNPw/HIcX57OdOLNhgHiFmcGwnD79/SOOGcwtymHix3+X/XzEHRyw3zpv0z/P5WG
         Ram63RCw70PMOGgNfVW9Nq497QRvJV8T+VLX001rXCzg1c+MucbcNx8ml1LkUFnLgjvg
         OOfwSep0SdFwhfpoXtZVUgN+wUlAK8I5FqdhYfyiD6d5Gnsv/nPEDYExpqdBilqAWdV1
         r0eDZGj71Ek7FH3jpx5YtBCAt9f6S1gMLqTLvzMjt5HnIeL1DnKVwIb1SpLvDiD/Cm35
         XC/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2MTXMIlz/dV0iBnAtnBofs7P8vQ/S8XF/YLaf2+qt2M=;
        b=JWPV2rjde8GxZxfH8QyIl86XQEJMmOJtuRjp8jAJSB3dyiMXWBF3DrlvVfKfWRR/1c
         LwVN091KRC5cF5BpoJLdKEoXtAmTZWCN82RqTr7bVUmjwejgeJoUvd3RBJScf3BBlHet
         K2VPu/w3BQqwGFY0hKlnG4SpG0TnPkiqE0bIDYzHpk61jKL9fAPVcWchw5JFvMrcomn+
         wQ07d59W46wbUMPsxTud5rJcGqux6zc4j06NzC0hP8Q8U/zLU0y7mHUfele+4LuhnauD
         JCqkIC0M7FqbXohdw+gigIKVQBFANLaSWWqLgxJ22gh90+oteIpY/QILUl4owOiTodW8
         Pl0Q==
X-Gm-Message-State: AO0yUKU6KscXdtaVeAvEwuWcQBy3w4WVB/iJt3V7NjRsYy5ANTVew9d/
	Sw/wpw7nTrZwsygyhQrvmsugig==
X-Google-Smtp-Source: AK7set8+PnfY2B8V9G4CP2Lj8RDaQp+dmHVQXgLREsohum+UH1nqFrxnkjraneEwoMXVj1dLQJOeqw==
X-Received: by 2002:a05:6a20:3ca6:b0:cc:8e18:420f with SMTP id b38-20020a056a203ca600b000cc8e18420fmr10210968pzj.35.1677456482521;
        Sun, 26 Feb 2023 16:08:02 -0800 (PST)
Received: from dread.disaster.area (pa49-186-4-237.pa.vic.optusnet.com.au. [49.186.4.237])
        by smtp.gmail.com with ESMTPSA id k26-20020aa790da000000b005d6dff9bbecsm2979685pfk.62.2023.02.26.16.08.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 16:08:02 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
	(envelope-from <david@fromorbit.com>)
	id 1pWR3f-002Wx8-CQ; Mon, 27 Feb 2023 11:07:59 +1100
Date: Mon, 27 Feb 2023 11:07:59 +1100
From: Dave Chinner <david@fromorbit.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	djwong@kernel.org, dan.j.williams@intel.com, hch@infradead.org,
	jane.chu@oracle.com, akpm@linux-foundation.org, willy@infradead.org
Subject: Re: [PATCH v10 3/3] mm, pmem, xfs: Introduce MF_MEM_REMOVE for unbind
Message-ID: <20230227000759.GZ360264@dread.disaster.area>
References: <1676645312-13-1-git-send-email-ruansy.fnst@fujitsu.com>
 <1676645312-13-4-git-send-email-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1676645312-13-4-git-send-email-ruansy.fnst@fujitsu.com>

On Fri, Feb 17, 2023 at 02:48:32PM +0000, Shiyang Ruan wrote:
> This patch is inspired by Dan's "mm, dax, pmem: Introduce
> dev_pagemap_failure()"[1].  With the help of dax_holder and
> ->notify_failure() mechanism, the pmem driver is able to ask filesystem
> (or mapped device) on it to unmap all files in use and notify processes
> who are using those files.
> 
> Call trace:
> trigger unbind
>  -> unbind_store()
>   -> ... (skip)
>    -> devres_release_all()   # was pmem driver ->remove() in v1
>     -> kill_dax()
>      -> dax_holder_notify_failure(dax_dev, 0, U64_MAX, MF_MEM_PRE_REMOVE)
>       -> xfs_dax_notify_failure()
> 
> Introduce MF_MEM_PRE_REMOVE to let filesystem know this is a remove
> event.  So do not shutdown filesystem directly if something not
> supported, or if failure range includes metadata area.  Make sure all
> files and processes are handled correctly.
> 
> [1]: https://lore.kernel.org/linux-mm/161604050314.1463742.14151665140035795571.stgit@dwillia2-desk3.amr.corp.intel.com/
> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>

.....

> ---
> @@ -225,6 +242,15 @@ xfs_dax_notify_failure(
>  	if (offset + len - 1 > ddev_end)
>  		len = ddev_end - offset + 1;
>  
> +	if (mf_flags & MF_MEM_PRE_REMOVE) {
> +		xfs_info(mp, "device is about to be removed!");
> +		error = freeze_super(mp->m_super);
> +		if (error)
> +			return error;
> +		/* invalidate_inode_pages2() invalidates dax mapping */
> +		super_drop_pagecache(mp->m_super, invalidate_inode_pages2);
> +	}

Why do you still need to drop the pagecache here? My suggestion was
to replace it with freezing the filesystem at this point is to stop
it being dirtied further before the device remove actually occurs.
The userspace processes will be killed, their DAX mappings reclaimed
and the filesystem shut down before device removal occurs, so
super_drop_pagecache() is largely superfluous as it doesn't actually
provide any protection against racing with new mappings or dirtying
of existing/newly created mappings.

Freezing doesn't stop the creation of new mappings, either, it just
cleans all the dirty mappings and halts anything that is trying to
dirty existing clean mappings. It's not until we kill the userspace
processes that new mappings will be stopped, and it's not until we
shut the filesystem down that the filesystem itself will stop
accessing the storage.

Hence I don't see why you retained super_drop_pagecache() here at
all. Can you explain why it is still needed?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
