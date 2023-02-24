Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339142902
	for <nvdimm@lists.linux.dev>; Fri, 24 Feb 2023 09:06:38 +0000 (UTC)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out2.suse.de (Postfix) with ESMTP id 5909D60282;
	Fri, 24 Feb 2023 09:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1677229596; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R0FfrovF/O31aPPxrZXgVE7XTofO4HjqjO2HkdXaTZ8=;
	b=of+PvA8Dp/v6+ZIJvmLy6LZzHvY7KHM/ZTaCsJPno1H7+7sQI0ScN/Xz5e8AsZf8kpjrOK
	iJG59Zjez3GoKcizBriDAWkbWvrg9n03kibaXOp5D2t2MvsX7Y8q2tNxE9xKpVYU0M+w+p
	CobM22stPmBmQkYGcEWyY5mlDxJj9HI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1677229596;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R0FfrovF/O31aPPxrZXgVE7XTofO4HjqjO2HkdXaTZ8=;
	b=22m0hT3MK8OBznZ6/VPv2JWf1gKHoQLCBbKzHh7BNumQStjbdeH8SXJY4nspm3t3Ko7VoC
	VVlV/Ui5/bIWc8Cw==
Received: from kitsune.suse.cz (kitsune.suse.cz [10.100.12.127])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id 2C1262C141;
	Fri, 24 Feb 2023 09:06:35 +0000 (UTC)
Date: Fri, 24 Feb 2023 10:06:34 +0100
From: Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-cxl@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>, nvdimm@lists.linux.dev
Subject: Re: [PATCH ndctl 0/2] fix a couple of meson issues with v76
Message-ID: <20230224090634.GT19419@kitsune.suse.cz>
References: <20230223-meson-build-fixes-v1-0-5fae3b606395@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230223-meson-build-fixes-v1-0-5fae3b606395@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Feb 23, 2023 at 10:45:37PM -0700, Vishal Verma wrote:
> Fix the include paths for libtraceevent and libtracefs headers to not
> explicitly state the {lib}trace{fs,event}/ prefix since that is
> determined via pkg-config.
> 
> Require a minimum version of json-c for new APIs used by cxl-monitor.
> 
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
> Vishal Verma (2):
>       cxl/monitor: fix include paths for tracefs and traceevent
>       cxl/event-trace: use the wrapped util_json_new_u64()

Tested-by:  Michal Suchánek <msuchanek@suse.de>

Thanks

Michal
