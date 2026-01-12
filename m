Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CAC3876BE
	for <nvdimm@lists.linux.dev>; Mon, 12 Jan 2026 18:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768244156; cv=none; b=WhrzwMh/GT8afXxKXOSiPOHuTq15RFluyzNqx6a5dNub25YQKDaMOMxoypescHwkvCYC7OEDlKsOp3ixGNX7JsvX/kYK4u3xU6M4A+iVt/RUE6X5V2U0e7jxly3VyIVptzw3tMzq3+HmpK+fD22qn+AWOoiftUFlrsxuJ/fo5Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768244156; c=relaxed/simple;
	bh=UclWX63fGn+76lJOJEAYUq4t4ohSd9HEsKoA1eHOk2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c0lpEJXUo3KWLjWWgMP3dFZqTTHqi0uCsusCTZQtjQxgt3087GfhPZ6amlh1CM6wDWx9bM/eRd7hh0c0gNqmGhokXwkqvqi2Tk3P174+jlMrblvjkZOt6OxSp9UNlfVRTOWha99O6OtTfjE0YfTOFdXLz21yzuMl+YsRgX+Ooyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RrsrU0xW; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RrsrU0xW"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7ce2b14202fso2920753a34.3
        for <nvdimm@lists.linux.dev>; Mon, 12 Jan 2026 10:55:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768244154; x=1768848954; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FYsHNBbYooeyWKTpHrg47SbkaPnJvaXLI4Q2tRF9T8s=;
        b=RrsrU0xWXksTpXk19vJPydv+1YcGHmNf4VcVY0JjmKI3WYg/rLpOkAoZfEMbmcDpPI
         XIWuBQiyFrOnYv/G+8b6q5xzpzNlWFLHhFdCqQ5xRutML05NlKFiZ2hjKPIf5VDTeCfT
         L9i94xSdI3Djr1l4VuWlmcRIPoXHVuEMV/bfdEPBf6p0rKbk3nVSs+q0TTrOlmTwgIvR
         RG3NBsiuex/WuuJeayaMixl/Vzwln47fWtkzvdzwt+TPg/qFjXVG5cA8bzN0ADezKX0G
         M/Va1/3dJPSoE1RzV5wucKhP5WZ45x4bGXQQPRp8w8XQJXbTErYcEtsNxazkDGWTmuZM
         sBeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768244154; x=1768848954;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FYsHNBbYooeyWKTpHrg47SbkaPnJvaXLI4Q2tRF9T8s=;
        b=t3YSf4/MMmP7ThAh/3AiSQwBprDmoTfkkuyrtRcs/8I3InnI4XF5m+ZyG7Tr/qB1Ze
         7Ew/0hSSCBiW5AL437oGANMqlBPoNIqrGNQjQ/7Bqy+pckrlXNJzgTZvR/j40kysoBJq
         l8sIGEJOf8oWt9NCvyVr/3ApDmLwNHQeIA5zuN7o0JP0jqY1wn650QXfTTV7dhtxazTf
         s6/s2RFmpRyQUWoJ6+tFka6UaEsePzO6q9XAtwt/nKctb7m08vGyVKNkwYqChqmScy0U
         9YzUJQFQpaKqVdDOC0FJVKBhkqs95zS7x8TvC+zoPEeTEELStSgHuSQtmfGhQbUNJ8n+
         wr4A==
X-Forwarded-Encrypted: i=1; AJvYcCU5CAYG5sTTpevrAzxcUrgWnjy58wilCHOOhZxjTN01/U3Aas0y/UGh1QRmqpKmPBcRkCUjByU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy/P8JdQt8GCDV3sxNinybGhhNyuewxGQdUj6SrdRy3wcbteAsR
	PKvnzjRz6BKMEqBc+T23rd/jxFE/YXD/MeW3mvWRpzJ8VV4+JnUq8Agc
X-Gm-Gg: AY/fxX5wsYuHZSd/aNJkFOhFgcBgOVTcbOkn4gYMwPRVx4KE+9dGqDIIN/MOX2RFnCM
	Bwu4R8sKlFKXZQwbcLG1BE/gHs1O7I6mgK9EkzSsSkatfPlrBwrYOVCc2i63vLUFm/giak0e/bl
	cPvidzhi711FhI3DObxc3jiMEy9bisq9NkSFQ53v/7ILriLUTlkGh4/lZDgbii9DrrJ+EwsENBn
	jRHfntZ7zMLZJn20zQC4tsTjP4NctE4DzcgUZyoTOlpZUuknik0e6UYvM0yhHoRKOyp05GbpZ3j
	9RsViX6nrhlP/OiIOYQ0De7O9SFe40TEN5bycpAh2I5O6umfhjqSYnu+nLwJ0z3tR3q5zXHeIDY
	ZAf0tUEEBBQTDWs+xbzMXBYEZe03gJ8jXHTvGHPz6xzHcggZSDjUshzPaYdMEQvFDfiUSK96q5N
	tQAjg3IwwynjuxQ0tNW3orW4qN2rCn9tWlNOY3O7Ei
X-Google-Smtp-Source: AGHT+IE1iJyYHUxrRRJzQnvZoITdjEtERZksRqGBumj+1tozUwX2FshEuhzALaYG8xEGOVq48wdoFw==
X-Received: by 2002:a05:6830:448d:b0:7c9:57ff:4cdf with SMTP id 46e09a7af769-7ce50bef39emr8458614a34.25.1768244153635;
        Mon, 12 Jan 2026 10:55:53 -0800 (PST)
Received: from groves.net ([2603:8080:1500:3d89:b02d:f13b:7588:7191])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ce478af6efsm13473549a34.18.2026.01.12.10.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 10:55:53 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Mon, 12 Jan 2026 12:55:49 -0600
From: John Groves <John@groves.net>
To: Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>
Cc: John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, Bagas Sanjaya <bagasdotme@gmail.com>, 
	Chen Linxuan <chenlinxuan@uniontech.com>, James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, venkataravis@micron.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH V3 07/21] dax: prevent driver unbind while filesystem
 holds device
Message-ID: <fcik72d66pfzk4xvubywt2mzdqr4lqtqjgexrqr3l3acpxc5hv@vp6oueyvzrll>
References: <20260107153244.64703-1-john@groves.net>
 <20260107153332.64727-1-john@groves.net>
 <20260107153332.64727-8-john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260107153332.64727-8-john@groves.net>

On 26/01/07 09:33AM, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> Add custom bind/unbind sysfs attributes for the dax bus that check
> whether a filesystem has registered as a holder (via fs_dax_get())
> before allowing driver unbind.
> 
> When a filesystem like famfs mounts on a dax device, it registers
> itself as the holder via dax_holder_ops. Previously, there was no
> mechanism to prevent driver unbind while the filesystem was mounted,
> which could cause some havoc.
> 
> The new unbind_store() checks dax_holder() and returns -EBUSY if
> a holder is registered, giving userspace proper feedback that the
> device is in use.
> 
> To use our custom bind/unbind handlers instead of the default ones,
> set suppress_bind_attrs=true on all dax drivers during registration.
> 
> Signed-off-by: John Groves <john@groves.net>

After a discussion with Dan Williams, I will be dropping this patch
from the series. If the fsdev-mode driver gets unbound under famfs,
famfs will just stop working.

Based on feedback so far, V4 should be coming in the next few days.

Regards,
John
