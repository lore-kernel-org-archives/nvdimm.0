Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872EF3644CA
	for <nvdimm@lists.linux.dev>; Fri, 30 Jan 2026 17:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769794480; cv=none; b=OcYr6GindDIpAJSoKoBWsc7G05qxKHFOrttgd/jy3s1GBdAiUtbhXEdeQ8/tvWW4lZ3TobK/Di/nZgwSseXoahqEk++WswBtpfOc6DYDNUOujFtWDLSaKDcJzbBt7m5O2623nFl5SWfkM/Bp55aTzrLJo5iWW6mvO2R0ZKXRUPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769794480; c=relaxed/simple;
	bh=po7edBQiBk8FP/oPhiDSEZOovfiZ88dORRyTLqEoIfI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UqsYBH/VQdjjsS/ANmykI24SYhBRBfXn6g3+x6FLwPVmacGNtHNHqoAkI8rt23AuXok0vT28UtVwCo50S11ihOyl/an+t3M+2sntcNZ70fR7NPFNDMbOkhRkwCJLzdxHQxD+U6gu+d3USSmAMD5zapJzMZ7JEYL83eClNHey0pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=qrpTrGD4; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="qrpTrGD4"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-5029aa94f28so19469221cf.1
        for <nvdimm@lists.linux.dev>; Fri, 30 Jan 2026 09:34:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769794477; x=1770399277; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Lr0ACEC4r9sTM7XeNDuo4Q3LP3+bjrKF/ES76GEt9Qc=;
        b=qrpTrGD48fBzpR2FZJFiF2NESwYVTu411vxUJufQFNsrxsuvd801QzTOYCeAF5wZ64
         De1SJzkbmqPO2AN4cNlZqT/AwI5dIftHeMRrO0XhcrMjOgwteOWgzmPneX5dPfF6pnsf
         q6PcToX5YkHfRYyV1yvA+bzm0IUrstdpMZn+XqEm890rEsEh2agf4RJdX9SLJug0l/q1
         PeAWE6y9u1ZBd6v8E6MwxtWWtSVXIwnwXFO4nXe3HK0utv6Y9MVfgJL6woKzMdZd95KC
         TzQesIJT+NVbrCRiDy/ovHwuEvk2jGGwzTt0Vk/MVm1O4nDXI7XYbSqKbkz9hFjN+JTP
         ooBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769794477; x=1770399277;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lr0ACEC4r9sTM7XeNDuo4Q3LP3+bjrKF/ES76GEt9Qc=;
        b=lONME9c+ENOUqgIU6xMuSorYSEQDF1ts2NnCXceeqw8LFrNQHC3KwHfEec6Pu1s/Cn
         S2QNHJFtMzz+4ZkDHzcLhR/LV8uSmDdSnPzpOZWbC8js83LIsR/uSARmZkvw2sWX4yuQ
         QmX3ZdTMqZrL33T3Gu3c6lBkhrWbL1wbXwemLdQh+Op7So82WbyYGXCdvefVwHjcP0ls
         ZWa/dcK6BpsQm5z1alXu3qGJoKMMD6/PMqi3i6ltbmGaRvyar1ppbRMtKL191SQJ7MTV
         1wC9jbPJl5AvGmirjj1IrMRPPkXh/trpjAm+Oxi8fpO0ZTgsfpeOcQZ1/nHRoAjFqnQZ
         Jpbw==
X-Forwarded-Encrypted: i=1; AJvYcCX2tw3+p/R+18MOaNuNkq3oyRn4NJsLuPlE+nStMeRYgPcKQqrirgOGn7IVyetIaiWbD1jCONE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyw5dKk4Z4T7X3o9Xn4ApRaeG/gkRdIs2m0Y5W0R7X/U3n6R3Jo
	VrmD81OF0+8TAw9A4zXdM50fL6KX4t4qWD4LzHKNnEfxEmoTVckSi/yoJJrbCXTo5oQ=
X-Gm-Gg: AZuq6aIjSkOCkjmnxRZwaek5v3daHQUo7xv/EWwwP+BGT8ueqNRtT4DF5NQaCjXNIPy
	FOmyPTMjS6Zp7vz3VYyofrCLI/ycpjvEFBRZ985siOaGjkfzAufRMu/dMIv1PBVPoxfZKuwZ0R7
	czc5h+bnhwGv61mBpE0o2K1kaJvZcWXWdJlvexcFRK16DiRhQxv2bGGqjZf6fbd6oz6CTYigny+
	BYrdaTh/Xrf/zwD4Aspoi6IB9a79TUf+mt5r7H4d4p/iJ/7GvPUMG5s+L8AGkgEf71in4JfUb4a
	rnctSYy/7sYgHLhfRd/46A/qCRxplN/l1bh1JJ1Sr9+kmeLtsUgivD9NHkrZhdWBM0DoKMki8+5
	nVOxadn42IxhEaq8aTG0b64De0CQFFjAlMws6Ux/W4Q/1ttLEnHzf+OEv9/rdi+7c0U4QfT5Bpp
	+MlAeWlcykL/sfLo5FJAPypkuPMNfz1dDPzgsFvKCzBPw5potbwt3y6Rzatyi40qoPqLjDBg==
X-Received: by 2002:a05:622a:20c:b0:502:a1c6:3487 with SMTP id d75a77b69052e-505d289da0emr31891651cf.1.1769794475777;
        Fri, 30 Jan 2026 09:34:35 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5033746eec5sm60844171cf.9.2026.01.30.09.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jan 2026 09:34:35 -0800 (PST)
Date: Fri, 30 Jan 2026 12:34:33 -0500
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kernel-team@meta.com, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com, dan.j.williams@intel.com, willy@infradead.org,
	jack@suse.cz, terry.bowman@amd.com, john@jagalactic.com
Subject: Re: [PATCH 0/9] cxl: explicit DAX driver selection and hotplug
Message-ID: <aXzrqYOmgo15NZ7s@gourry-fedora-PF4VCD3F>
References: <20260129210442.3951412-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129210442.3951412-1-gourry@gourry.net>

On Thu, Jan 29, 2026 at 04:04:33PM -0500, Gregory Price wrote:
> Currently, CXL regions that create DAX devices have no mechanism to
> control select the hotplug online policy for kmem regions at region
> creation time. Users must either rely on a build-time default or
> manually configure each memory block after hotplug occurs.
> 

Looks like build regression on configs without hotplug

MMOP_ defines and mhp_get_default_online_type() undefined

Will let this version sit for a bit before spinning a v2

~Gregory
