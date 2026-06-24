Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8075E2EEE66
	for <nvdimm@lists.linux.dev>; Wed, 24 Jun 2026 07:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782287401; cv=none; b=Y/XRfK2k27EjJwTocJVsNTJb0JyWJdkZUSV/zLn7Se+DSaDofqiY/k++q2Vuvm9+4ItGrAzO6g0VCVQ6XeydbCX+MWNfppqyar6Um8j5CEk8rta20DWiyNoVcYfrgQAxBvRk0QUeUNr9+mimJTbCR98bt4dzjweWvittHdVFa4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782287401; c=relaxed/simple;
	bh=48CBAiVLI24/iZduWhrvqOuRvaOxBYrMQGx5TphZKVI=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A+NjpadXiR8InBF1RNVAtnYvjLNZrhrmWiqEGAFlwl8qcF0eGYbpsMloJ325BEFXoKhaX79QNFExKfd9md9vr3qmhJnD+9SVBYsBbsPPp8BSeYQ7U4KkjAkeW5RH81E6OunMMDsVFFHAdSoqEzYmQpKdr6lPkdcpIEgkq/27ghE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TfHCqtur; arc=none smtp.client-ip=74.125.82.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TfHCqtur"
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-30c713f37c2so113666eec.0
        for <nvdimm@lists.linux.dev>; Wed, 24 Jun 2026 00:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782287400; x=1782892200; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lnkemTVFtevu9LEJarGGlEd0BNgo1KPMK+RxKbsyiwU=;
        b=TfHCqturUjJzue/LctppwrXQCo7Bk+ORg1SjyjVbaETWhKKD2/KmCCvU3dNVl2ehp7
         88h066IhVEb/lSJCKEs/o+pRS6Z020ZgHYQl4aZkDzktP1Hb0cr0QLEARu3AhSPMGdF2
         C0j2K3noa3yBMVXtLhLEbh+wH6f0wjd9T6nxzSFx15uNXTsEjk00Eb+cNGETGRW7cT2E
         F8w9SzTJGayH73S9XwC4Z2xntwBN8Xb2/DTtpQBiz/X3U6KloXvBw6Al/FLPhBNw5Z/T
         A/rJz/En0n9eejxnctN4E6GhDCrP6a2y1njIwY37d+Np4ytdhTneQst2DDL0ZvttuN7j
         Vgcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782287400; x=1782892200;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lnkemTVFtevu9LEJarGGlEd0BNgo1KPMK+RxKbsyiwU=;
        b=Fae6hhVfJXizGCTl5+qXRigFZqEga/dUM26WryGvZctA1ffKArESgSz02+injO99w/
         AaO+M8WQ2FY8pWQpUDCqVCksr4BCIDBvNMbyDq2V/XP3VfqFeXLapPCFlZ7FiZKTnn31
         6x77fza9wvetbtLpD29rz30tQKWwiy0U/QxIEyXxYc4EummUPwLNtSVigF0Pg9trfqRE
         RR9m2zeze3sq4CYeipTMcVqs2gc5jYWFSoJ34P62ealdoY9svMS//b6O6lla/psf808b
         WiC8l2W88rWOdWdNqvmigs/GpEd46jH5ToHchKQUBTdsyznnxctyb8hWWv8c2CJ6bIf+
         BBmw==
X-Forwarded-Encrypted: i=1; AHgh+RpVuozEkgJ8ngAaZbDTPawVrLED0rqPkKqTXeMT3uYvRL2e7+NizEYFdIAUPJ09Hu6+IblmtDo=@lists.linux.dev
X-Gm-Message-State: AOJu0YwdujzwGaw335bXCpeVOE5SKVvdwVw8fbZNBAlid5HEZx6KDqqP
	seqDYjUeCR9Oast0qcDwhA+LgaJVRs9dgNowE147afDwPglf8T7mUR3I
X-Gm-Gg: AfdE7ckA8k2l0PQ9V0y3Xln6R/8cBY763XjP1qI/MpzawHTk2AXi1CyMP6gCEDzP9qo
	9FFrwOq66LexIlcGxKjdz4NUFiBvBO3MCdFK+SZy8Y1JfGkKhciYBccSoKeNizpAri9zjgR1mbN
	Yv4nSQWoTN2b/b0JWjF/zV0FrLnjp6Cpdl8vNbI6v3DvEzSp3nu/aKDsurdLyfnsVbdty7z4/CA
	dbJsJv4u0j1XlouH3XC2aZnaF6TLbAJZLD3Vt6x9tXWjff+yQxo7XuzYwJ6JNx65R4NzaQqbfyX
	n0ylNAc53p1QOrckeaol/5u1XT/RdRSvzNsWyyIagQsepfsXiiB90e810tIzHkqDxE34VJ5CwdM
	g4mj+n6067anqo3LPZ/fH/XcG2bPJVDQ9Js6IKKqKg0OUZg95MoIdj0A0euf3Oo87rer0B/othr
	5uLVsPyuxTUo11czOGYC01zEAke6+DkKrqbXs5zdjbFhkvYyxLwV4Phbh4czndfEgPgndsYd1jM
	4g3cPo=
X-Received: by 2002:a05:7300:1801:b0:2ed:a58c:942 with SMTP id 5a478bee46e88-30c5556303cmr6682109eec.8.1782287399572;
        Wed, 24 Jun 2026 00:49:59 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c1ba57dc4sm21112608eec.9.2026.06.24.00.49.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 00:49:59 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Wed, 24 Jun 2026 00:49:58 -0700
To: Anisa Su <anisa.su887@gmail.com>
Cc: linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@groves.net>, Gregory Price <gourry@gourry.net>
Subject: Re: [PATCH v10 00/31] DCD: Add support for Dynamic Capacity Devices
 (DCD)
Message-ID: <ajuMJi5nTQRB_ZP0@AnisaLaptop.localdomain>
References: <cover.1779528761.git.anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1779528761.git.anisa.su@samsung.com>

On Sat, May 23, 2026 at 02:42:54AM -0700, Anisa Su wrote:
 
[snip] 
> This series:
> https://github.com/anisa-su993/anisa-linux-kernel/tree/dcd-v10-23-05-2026
> 
> The corresponding NDCTL branch:
> https://github.com/anisa-su993/anisa-ndctl/tree/dcd-2026-05-21
> 
Making a note here that we were also able to validate a very basic
case on real HW of adding a single extent on GNR-AP platform with the
given kernel branch + NDCTL branch, create a DAX device from it, as well
as run the FAMFS smoke tests on it.

Since I've made a ton of changes based on feedback and plan to send out
v11 by EOW, I will ask the team helping us with this task to try more
cases on the next version and report findings as they become
available :)

Anisa

[snip]
 -- 
> 2.43.0
> 
