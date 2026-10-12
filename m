Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65A448E0D9
	for <nvdimm@lists.linux.dev>; Mon, 12 Oct 2026 16:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791821922; cv=none; b=u0LNexuqYgmYTZuUZ7DE/I7vQhc+cD2OPAXh0KVsnsBhFnF83O+gwXRAizNpOeXcRkDN0qCDMPJ2DfmwArfxwjkwaxcv+mWOUtBOwgFhs15T6LYOqoOTAyBIGYIGlUdZJ4e+qE6pooT8kbXMMS5yZmyHP/cmLAzIJtq5hwBb0KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791821922; c=relaxed/simple;
	bh=4YpWVz2t7P3nkCK75u6xOdBsc4nHUlNeMIe6NmdDkAs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Iv58mEVocDYHQEBIZsRQkSA6/9ZozuL/jz3VJLcmv89q7TjF3O47qttdnrXq0MkTTI6mLGqCXTPBuZXr6Lr79P0HX1IPpoqcecD3abI8cX5/OLJj3M/hZEK19lkE1tKl71+CQo/DnDqpc6AcM9ONpo0QjIe82NOxB4yqQbgoA6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=ubvyKBzV; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="ubvyKBzV"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-93cbee4b010so122979185a.0
        for <nvdimm@lists.linux.dev>; Mon, 12 Oct 2026 09:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1791821919; x=1792426719; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ycCA/46fGP9bMzNSUFEULycpfUfNegmWCSDBNo9iDiA=;
        b=ubvyKBzVDv/BM7Fr4Y54BLd2MhX88gbH4GJMFvapbNl5hDylvr1aLe7MjGmuJzjV5p
         sJG4h5jOesWnt82OTqwOycUwOmm0XPbAZgyZoC1X+DADYWDHLk+FfSp+P3c9lTTZEBz+
         +5raWptlGm22PKFb0kWDPpeTQNflthrXcQTcj0aM7rQzeZwCjUf428pFNuVd+hmjgffp
         8kh9C72iVRcynfiL0hWFWID+VIkpNsHdxAzucLm8sHLx7fLGy6eKzx/OVeCShHilFsG0
         zFQvisWHiiIGOUjTny1WDVlt3fFuO8ajCXtL8V1pWLGC4qOW4k9oD26tBd/+N8zISW2C
         wYoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791821919; x=1792426719;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ycCA/46fGP9bMzNSUFEULycpfUfNegmWCSDBNo9iDiA=;
        b=O3TJdjaqXo4WEUulGvc0WCKRt2YZwEPTT89caVnBZcoa2Yc+yUSOxrlTIVu/Tuuq/Q
         lFmMNG97sGV8mvu9W0FPjeYmioEqQv8r4RjcTXZSW+7f8ma7QYACd4qHQgP5PmeQ2pYT
         obSTia9V3NeYuB8W6fUmdF62vxnODfSvhdFIWSS3TFY67b23T0cMXLgV3OXY25yLh635
         ZzLZuuj5DJQFJ3AYAP/vOUorzRNlAG6nDzuwAgun8VdJtIDwRD4sjEG/IM2F1WAo0O9d
         N0VVS7YA3UJW5oAQFEabGSAfzk5d3ohLgwDDArGrGNeKUrJ7MWMro8Uh3u12gXah0K8v
         mI+g==
X-Forwarded-Encrypted: i=1; AKwUvBzOsZ6MDjPdqf/hmtx3Wt8hnctjpVSWrOxW/SfE0288ed5TsunsziHHS3hXvnPJqv0rcQCgCZg=@lists.linux.dev
X-Gm-Message-State: AFq9FYIvWMTtV57Hn9kxNdBlm3QSe29aNyaRRZ7B+pbkvhqZ0LPNQVG0
	xZeJmE4KzyMWmRNqTh5QEudn0ayi7p39kgE1w2eZGEtiDBmV1tdV3tDVnF++avGi0+g=
X-Gm-Gg: AYBFou1oGYcg5/Cph+inIC7DRcvbjDE1jpAHHyJ3i1f1IBc2+0hsPP1gA+OR0/t8aap
	keE0lssrtye5UgZTzrxtr0okjts+KdYm+QIKcQp6gN+d1lOQ5V5cMaPLvtWMCM2uyhnk7ps3yX4
	0MSiIQujm/QIaK2UfUMc4fBO28mgipNt/vXmXHJzL4KqECWknt3z+vp4Eu+kDS7+8QzmyhVHG0r
	O9uw7OOpnBEyQyVtCbTxLHyuffb81V6AkODLjI2r8Cg3/YkyZOdpEanXPUC4umz+jsgrU9NP92G
	pq9NQ4s+O6y8g0iiemUvzOKd/fLQidHKdiMs8KL3oWvJ1Wch32vX5jT5keWDhhoSn4hmt60H/2H
	+7KfuhbxdapA8fRInKQsQ596Rr4wiYRXXRP5KePjpE9QutflNBmgfPs2XkNXLDzGiUn8scJDc+5
	O8ydjdBGXIaD6ywRybYzRz+iYOiBJDxmwueO2w6AAoNKF+/TyWDgXbApHQ4s43LuG1EFlcm/wh/
	jjoCkQesZqjux6Xl5ci3pI1/UkyJdOzZXYyvkazLyMWnLSq+UTPAcE=
X-Received: by 2002:a05:620a:2981:b0:939:6df7:73f1 with SMTP id af79cd13be357-93ebd27484bmr1635268185a.51.1791821918598;
        Mon, 12 Oct 2026 09:18:38 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef50295a7sm20807785a.23.2026.10.12.09.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 09:18:38 -0700 (PDT)
Date: Mon, 12 Oct 2026 12:18:36 -0400
From: Gregory Price <gourry@gourry.net>
To: jianyungao89@gmail.com
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alison Schofield <alison.schofield@intel.com>, 
	"open list:DEVICE DIRECT ACCESS (DAX)" <nvdimm@lists.linux.dev>, 
	"open list:DEVICE DIRECT ACCESS (DAX)" <linux-cxl@vger.kernel.org>
Subject: Re: [PATCH v2] dax: fix dax_core_init error return code
Message-ID: <as0IMU-uIENTAXSW@gourry-fedora-PF4VCD3F>
References: <20261012151857.22534-1-jianyungao89@gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012151857.22534-1-jianyungao89@gmail.com>

On Mon, Oct 12, 2026 at 11:18:57PM +0800, jianyungao89@gmail.com wrote:
> From: Jianyun Gao <jianyungao89@gmail.com>
> 
> dax_core_init() mistakenly returns 0 on error paths. Change the
> error return to use rc so the actual error code is propagated
> to the caller.
> 
> Fixes: 9567da0b408a ("device-dax: Introduce bus + driver model")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

