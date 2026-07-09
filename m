Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B225301708
	for <nvdimm@lists.linux.dev>; Thu,  9 Jul 2026 21:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783634228; cv=none; b=fIDXgJvjbilV3WxsFv5+7cyj6o3U2H7Jk2NPwq4EY8huAD7S8wY0hGnfIodOqZ0jk6LhVlIwl226tI001H7QCh+DAun4AQE31K6RN9Rm9T0BKpk0BpSM3Vqdqz4rRRSeLBTLELIpkQPL16x20SL6kXgGjeWF+VKlJ2rH2tm447A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783634228; c=relaxed/simple;
	bh=8UAIjOhvfbKjsQ/HTeZBSW9rJpTCzyIJqdF78M986Ac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X6KfKSTftbqXlKXewqwNkweo9AzK4WUB9+Awgf7uvYsdBz6Yi3aGxsZmZALSN0TvRc5uRe7E20g9KVRMvnEzI1I6BrEoFY1aE+7NpzzGtD4VyQQulHAmUU3HW/QAinU3kW/ER2jZpeFjuSeqdlRb0O2QLqSaPNI+BpR2tvITHlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=NI0Bzrk0; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="NI0Bzrk0"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8f1e274ccb9so2270796d6.2
        for <nvdimm@lists.linux.dev>; Thu, 09 Jul 2026 14:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783634226; x=1784239026; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1AtZcCJL7SSO55KaeQpBRgHzud/kdG6WTG09Vy9G3lc=;
        b=NI0Bzrk0qnpbllLAG5iWFXZWqTxIoiP+LQZ1AHmUnxAfq/LfzjLSybMP/S2OAaiG1e
         5cpce1mTM5MfJvNK7ftCVORAq7g2tXOqnHv3PH8ev9q1jY651SkkrQ6e8+Hhurj9LJYF
         yXCOAoYscT302rowOA96skUvYbGeiM0tS4rc7deOpidIZT1zFrwcIeA0xHdVFJ44h4ce
         52zdoDKYm2XzRmPqe0IctSUMkb6CM68XplK5a7oxJhp1lX9q5cq/c6G51SsFFUkMsohI
         pr27a3tr3DESlNoRg4FFUB7cs9fmDsGHr+h7AoVVJ1xebdzAyO+w1vKbMHrIOT2iefBE
         r9aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783634226; x=1784239026;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1AtZcCJL7SSO55KaeQpBRgHzud/kdG6WTG09Vy9G3lc=;
        b=g/HvAe01G22ah/WkTKo2/Nuc5qNr6ozAFKPBxZa26NWyjwG/jCm9Pqo5W6tDD6njI5
         2fTprc5/8a0kCI0Z3dYXlgPo3dWK7vD3v/6fSGgDh1FUWWaMZwOxjPajGbqK3MR6RRYP
         Etxa9FHe3oDoDKodcQsIT5KwA1QtmqxspsAISkwUUziXOK47sikeXEfnxNKbpdPOyS0K
         iB5nijenO7v0OoJuxqeN9TZK2R8Cih+GY0thxDxIUe7PVuCMNrFHdXmAiphau/BrVysg
         8F2mp4S53fAJvOnYes7AC/mcR9LdgC9p+FtrqAx0WYopVjqUhttnmASTOVnamiYVP8Sr
         /6BA==
X-Forwarded-Encrypted: i=1; AHgh+RpuhjfGZrPBK9gVLiF7TpYGJZy0jY4KtFL4hbzCf4/B4UDkcJl7CtqFZHXBZZUmbhJ/IlcFrBY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxbabGtzDHpjyFojnjPcdttczzrI6xUdJR3YuaL5F8CBGIRsMth
	zB+s4WD2HqgRImiHt0DZ4IgSeEKFM4xLf0shWeEynJpIH+PFRVpqQZ2X3u8REVk6LJY=
X-Gm-Gg: AfdE7cmVRJJAnSAPgQHQrbJfUA/cnmK1kLx/frPd1XtQivKstqX2iNLFkYePT6hkUOU
	GtD6nkjy9QSbL+esN4QRcj0JPx4+wfe31HpUaOt/R9aQaSZwERz5+iMKyobTaG8H5X96EfRcM29
	FCA3AS+kj1jkAAPbbvcYtg0bulAN4d4AHHsC3AFUr/OEjgO+Nke8C5chOz8HCKmlYyaW5DcQ+Bc
	ES00mN0f4HObLw1AEyix2N8nE37OfQn73ih3B+20CBEBE/rWIkl/yeUVOc5Jf4mLTIz/6aTs4X5
	FYjxo8ypDS1PsfEEZbboBk5ggcn+ZDnqsbCYT6IMPCtkI5Gerq9Oqa1Aed9QJOPl7Q17gxicX+D
	u5c4f0aYakWQclNo/bHEwMd3QLWBtS7a05VUUb/i4bQOzE9WnbBhX+fPlRtfX8rTmWTj+61eOTk
	gIfo0v+V9NTEYYIemscTSS6rZnzd/fzr3Qzw7PRwRDFuxZOnwA6ic3b3ZCSPK7sUvC+pfo
X-Received: by 2002:a05:6214:2b83:b0:8e7:8d53:240f with SMTP id 6a1803df08f44-8fec2a4a020mr91687356d6.43.1783634226132;
        Thu, 09 Jul 2026 14:57:06 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd80fd82csm26977986d6.35.2026.07.09.14.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 14:57:05 -0700 (PDT)
Date: Thu, 9 Jul 2026 17:57:00 -0400
From: Gregory Price <gourry@gourry.net>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com, david@kernel.org, osalvador@suse.de,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	djbw@kernel.org, vishal.l.verma@intel.com,
	alison.schofield@intel.com, akpm@linux-foundation.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	shuah@kernel.org, iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com
Subject: Re: [PATCH v6 02/10] mm/memory_hotplug: add mhp_online_type_to_str()
 and export string helpers
Message-ID: <alAZLBqgUEZliwk_@gourry-fedora-PF4VCD3F>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-3-gourry@gourry.net>
 <bdf0ca14-eec4-43b6-93aa-310e77660d95@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bdf0ca14-eec4-43b6-93aa-310e77660d95@intel.com>

On Thu, Jul 09, 2026 at 02:08:43PM -0700, Dave Jiang wrote:
> 
> >  extern int mhp_online_type_from_str(const char *str);
> > +const char *mhp_online_type_to_str(int online_type);
> 
> Does this need to also be 'extern'?
> 
> DJ
> 

General policy i've understood is: "No new extern"

We use the EXPORT_SYMBOL_* family instead now

~Gregory
