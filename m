Received: from smtprelay.hostedemail.com (smtprelay0120.hostedemail.com [216.40.44.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD1E168
	for <nvdimm@lists.linux.dev>; Sun, 11 Jul 2021 22:23:09 +0000 (UTC)
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
	by smtpgrave01.hostedemail.com (Postfix) with ESMTP id 143D5180279B2
	for <nvdimm@lists.linux.dev>; Sat, 10 Jul 2021 17:04:58 +0000 (UTC)
Received: from omf06.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
	by smtprelay03.hostedemail.com (Postfix) with ESMTP id 3AF3E837F253;
	Sat, 10 Jul 2021 17:04:51 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf06.hostedemail.com (Postfix) with ESMTPA id 3852D2448BF;
	Sat, 10 Jul 2021 17:04:50 +0000 (UTC)
Message-ID: <10621e048f62018432c42a3fccc1a5fd9a6d71d7.camel@perches.com>
Subject: Re: [PATCH] dax: replace sprintf() by scnprintf()
From: Joe Perches <joe@perches.com>
To: Salah Triki <salah.triki@gmail.com>, dan.j.williams@intel.com, 
	vishal.l.verma@intel.com, dave.jiang@intel.com
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Date: Sat, 10 Jul 2021 10:04:48 -0700
In-Reply-To: <20210710164615.GA690067@pc>
References: <20210710164615.GA690067@pc>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.60
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 3852D2448BF
X-Stat-Signature: r9mp75uipcc9qgr86rf8isradagw5869
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19qjiJ4bEM3l7ZhvAJzq+B4x7oGaQz405Y=
X-HE-Tag: 1625936690-706479

On Sat, 2021-07-10 at 17:46 +0100, Salah Triki wrote:
> Replace sprintf() by scnprintf() in order to avoid buffer overflows.

OK but also not strictly necessary.  DAX_NAME_LEN is 30.

Are you finding and changing these manually or with a script?

> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
[]
> @@ -76,7 +76,7 @@ static ssize_t do_id_store(struct device_driver *drv, const char *buf,
>  	fields = sscanf(buf, "dax%d.%d", &region_id, &id);
>  	if (fields != 2)
>  		return -EINVAL;
> -	sprintf(devname, "dax%d.%d", region_id, id);
> +	scnprintf(devname, DAX_NAME_LEN, "dax%d.%d", region_id, id);
>  	if (!sysfs_streq(buf, devname))
>  		return -EINVAL;
>  
> 


