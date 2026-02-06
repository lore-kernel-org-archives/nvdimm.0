Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E1A3A7853
	for <nvdimm@lists.linux.dev>; Fri,  6 Feb 2026 13:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770384378; cv=none; b=nJOl+BFWpU1BzPO5gD6fecy6epww29qokeeZTB0+onP/fSqVFDBUUE4dqxduS2frSeOr0B+eknauhXXrTRQ480Si/dl5Oa1WwrjZQyMewl9GOicl8nO6T/Yraen7uEgHIh4/AkPRJNHnUDcAopcuDpDGXDYcS1BKLub5exwiIg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770384378; c=relaxed/simple;
	bh=QOyk0cfOiJKWpzq43+ntxyiecyFc7tSymZehLwBs/7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TMPoC6iwDmeWYgYr1qee7poYl46Pvx0T+0WwttbvaDXo+MpmoYn+2mKMnOvM5DTruZY8QIdDwduLFOZnnhIHb3jeG/88kYVOlk/CVdVPaPyYfWQI49K8FCe1+q5ddXaL3+hymGN4ppEsQTM+J2xm9R5YgrTY2spbiA/qC7CGTEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=VLbuun8n; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="VLbuun8n"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8c710439535so136006485a.1
        for <nvdimm@lists.linux.dev>; Fri, 06 Feb 2026 05:26:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1770384377; x=1770989177; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bcoHR9we9sqx3MppgWDXe17DIO+ggzqTTd2+g0R34PI=;
        b=VLbuun8nAz3AhsjL7hUsixtBaTYZAWtHtZnO7Iss27v24Pp+f2PPG+lcvHRwJIqvxF
         hbHbollUCT7KFkqSpat3S6VCx7jtqwfHYx1auk+mB1Lk2eQeLRV32+ID9zjDGe2nDin4
         blVUwoxXjRtTRIkvXjdyhffbXWql/FooLr19mqaUTU1jtwIgjH56E4tXWRQ8WM1lZBfN
         QXla9g37XiFWIcPPKCzh+9PpDzVKFsyg8Xc43eTTK5I2P06354Lf8rHNBifdiiJpZzKL
         n1j5xhMXJJFhEnhVG/YVaXGKxpQaHHvjpRXsCIXDUHp+qGmIB5bnkn9XM+sy6yXI3rgt
         9aXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770384377; x=1770989177;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bcoHR9we9sqx3MppgWDXe17DIO+ggzqTTd2+g0R34PI=;
        b=AXhFQq/dUhj6rhNhHqxzyuxGNuA4sOFWmXLL91GUJp8D+ftMOZiRnBS8/zDjemykur
         ffmAOWwaLO3FuUB0cEcqdfA231LvRfTwXA9phi6EPZagSopCsu1ZPJSZPSYXltU6lzcg
         rtnRw+NRuedSKQth+C6tSt6cpIO5PuBJlduJFMRhMN6nyzXwb/p7XbBOx2FLT0rQkCmW
         Y9VGkuDVeQxXPeTcFWFYS5D2MjQMnqeFXqHRE9m/VU3T6EwK+Ctzhjz5jSHOqurLJtJl
         iIN6coCIRMKAmd2+WFfSad5/cRmpjD7/8aqgEN4IUp9yC/wV8SHIGGesLWKDhnVncZZZ
         hqvw==
X-Forwarded-Encrypted: i=1; AJvYcCU7wrsDQKab0OIPaq/RV6iVp9Z0KN252EjFBHzCLkiXw/XICxhXG640K3LKi3iy7FyfAH0QnQU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx4bOOqdxTPeh/D/ObmsDhVuQir1pNWVmjE8UFmIVDBCs72cGaz
	KYEaFGxEYzykVCwBCCEW2vPafBUUCvF/+rKr7qnytjtt+RwuMKiippqrN+5i2Ow9/+k=
X-Gm-Gg: AZuq6aL4O5EB9CQaH6Cipc14dTZWVd6qAeZEsz50Q/A0cy9L0Rixk8p3otwr2jcI52q
	914JT+IWfJyMt/zevIKSiM7JZKw/yWE8hjy1eEbFNGevGY+vLUkZQSuRVeNb1xcxXUU7ECTs233
	tDTIBEwwf+k/ihLB+2c4j9o3HrJR5cKrBtE690GGxeEqxxJYQv0KpvzMAds9ldiOOj8jvCZM5Ew
	WF8CvsLHCGgxsIm0zLAtBBIWfdu2sHITzzfM6+fc0gqM0IQSPwIJi0DaBzPbGpwUnEVdemVs5di
	M9D0pHm2eNdrQulfamRUgKpwNQLQgfiLGh5kJhY8PAPrIEap49f0tlDAbnFvr1THdVdc2xCYl8U
	VI2MbtLsvBsvda71ZBkvXi9cgmc7uDSCv2jBqGCaMRqsgH2aLEwlZDox6ZuDIJ2DQ2HgOz0VZbh
	0d1fr+8YsxcYBpR4v8TQPm3gUHbkIzhZi5IOFpBI14DsBB2Th8PvGq3oXXF+bYtGoeflumpQ==
X-Received: by 2002:a05:620a:46a9:b0:8c6:b315:1452 with SMTP id af79cd13be357-8caeeb510c0mr350205685a.7.1770384376891;
        Fri, 06 Feb 2026 05:26:16 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8caf81c118csm157292285a.24.2026.02.06.05.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Feb 2026 05:26:16 -0800 (PST)
Date: Fri, 6 Feb 2026 08:26:14 -0500
From: Gregory Price <gourry@gourry.net>
To: Alireza Sanaee <alireza.sanaee@huawei.com>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>,
	Ira Weiny <ira.weiny@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	Fan Ni <fan.ni@samsung.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	Li Ming <ming.li@zohomail.com>
Subject: Re: [PATCH v9 00/19] DCD: Add support for Dynamic Capacity Devices
 (DCD)
Message-ID: <aYXr9u1Y50MBtEP6@gourry-fedora-PF4VCD3F>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
 <aYEHmjmv-Z_WyrqV@gourry-fedora-PF4VCD3F>
 <698270e76775_44a22100c4@iweiny-mobl.notmuch>
 <aYNh-m8BEiOHKr9h@gourry-fedora-PF4VCD3F>
 <6983888e76bcc_58e211005e@iweiny-mobl.notmuch>
 <aYOVm6PVfmQdZvlI@gourry-fedora-PF4VCD3F>
 <20260205174847.000065a4@huawei.com>
 <20260206110130.00005fc2.alireza.sanaee@huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206110130.00005fc2.alireza.sanaee@huawei.com>

On Fri, Feb 06, 2026 at 11:01:30AM +0000, Alireza Sanaee wrote:
> On Thu, 5 Feb 2026 17:48:47 +0000
> Jonathan Cameron <jonathan.cameron@huawei.com> wrote:
> 
> I think both of these approaches are OK, but looking from developers
> perspective, if someone wants a specific memory for their workload, they
> should rather get a fd and play with it in whichever way they want. NUMA may
> not give that much flexibility. As a developer it would prefer 2. Though you
> may say oh dax then? not sure!

DAX or numa-aware memfd

If you want *specific* memory (a particular HPA/DPA range), tagged dax is
probably appropriate.

If you just want any old page from a particular chunk of HPA, then
probably some kind of numa-aware memfd would be simplest (though this
may require new interfaces, since memfd is not currently numa-aware).

We might be able to make private node work specifically with membind
policy on a VMA (not on a task).  That would probably be sufficient.

~Gregory
