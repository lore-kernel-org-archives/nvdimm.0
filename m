Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1258D33C1B0
	for <nvdimm@lists.linux.dev>; Wed,  7 Jan 2026 17:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767806380; cv=none; b=mvVJ6w4YaMvwj5Noyd9GJq+sYxx3t5MLA0TARfGEg/3E3ckpoJhCuZ1YI4UVofz1S7FG70Dtebpe5pZ502Qi9xwvXHMTm/1TzV5a8k/5VPeqrNEr54cyplbyelR6fph2Qv5wtmCl7runhybe0GrJzGRfEPwNRWl1lYC8g6d4vlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767806380; c=relaxed/simple;
	bh=JZb4un39BlPP+OGm49xPg22uNlLarYMy/HsntlA1Vg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r6rngzAR2rCFCaWw+l+ek6bXLLuO0Xi6NrER6Y0jfrIpDorYZ5r6qN+YbtAQtJnJ0ftXT6msUIGrHwfkSev+pv9mSHtBbQLEszYnzfo2Zl9M/A2eWD2RE0BWG8o6TlQfttXuR5i7lL6DeR3vKhagW1ewI5hHfBTWz1fGkYnDbbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mBchSyrX; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mBchSyrX"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2a0d06ffa2aso18470845ad.3
        for <nvdimm@lists.linux.dev>; Wed, 07 Jan 2026 09:19:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767806373; x=1768411173; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=txgoLEmMjHER+EBzHDKZOrkZdUQtWotXYsSwAupxNQg=;
        b=mBchSyrX9pd1yzPKi875nQi0Jw+wnCyv7473eA1nPrLuLblj6OIjMVfiKzMvOsGQl9
         dFz/8I9GITO/0R4eFJsLK9EsJ+wD6fHiTrrGrb5U5A6YWJOfsjcXovJS/dsjUmyNf7RD
         F2xeiYqOrlGAJu9ao9dnOEjAHPxYEBTjHK+DUHjOQZtwgk9llBi46l8sMHE5nh0/hkNk
         f29I2gUNoNag+tWL2OpiXiy4BOoklA27bTytP0kOVT52BovgERhmmTjcvO424gk+MRB4
         kc9P5xyhwMAI+vS9iYLH1E8a6snOk+y+CZRs9f9Mw7DDfo1DJkHMgvc0DZX2n1xWe2bc
         yBXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767806373; x=1768411173;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=txgoLEmMjHER+EBzHDKZOrkZdUQtWotXYsSwAupxNQg=;
        b=O0Q9W2WGjtvR+UD1887q/c1AwMmoYB5AWUmd38u4fLTxyCoWKqymO12yROYzGtpZdf
         rFkhGZAxNa/QuyhHswzHcmhtjhwPH/V0dxGsLbWK4YwSTtRR5n0m29ibkGKaUJJJeb7e
         CRqdW1WQAif8iiEo5iifkvOTh74+AQv5pUGW+i3VyxGFr6E7esM7TkMxY1401XOEEYxC
         99ql9fe2Xybp3+lMepNmDqGPvx8VxhQFLr2lJ7aahqIdP5AQFxwwtvXdSwyVDwONatpv
         PE7HG1IGkf0UMwIU9mqo4Od69B0rNPYky6jkgeThF13mADeS7IXLSpRRTqDtpnSGEcXQ
         6tpA==
X-Forwarded-Encrypted: i=1; AJvYcCXACKlU4WqVFLg2mFxeC6ieTHEibvu2OvAoclbTyOPSVdopOp7rw30yggUmZZwXsit24ykhsBI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyb8O0pxw984OLuJQ8as1PoVJrxRFJhdBUsoQpT3EnqRdxBTdqH
	J2PbkfI7D9Hr9lNPuoHJGSoeTUNLmkuhl8aJyV5a/YF03SBnrp5Ngcpb7UFfew==
X-Gm-Gg: AY/fxX5xCoCwtwr8zOxgbrY/ozL51XCNRBvTj1BI0kQpZxxA0la4Pnux19Wu7O3TXsA
	8bvWfUggGvsGsdsTkG9FgmmD8CQT2zXK31MtTsAwqrGdU3eoqv7T06kWU34vM3k8+0husmdeUqU
	QQKnLRG6Pv9PJUyWahh1SIZcWX0+XZqGVhdB9K1hgcGmqObhIlJoVt9VTIOnrav+ZBK6GgZgNpB
	LCK8DxW+BYuvoBIEbQSHWkAHfGVWnVGORTf4up8G6bz08/GQG+5CWyKmafpz85Do5ZZhTef1s8R
	+Mpjb1johHloq7pZ/Oen6i8CLfshEtNfnYsYPB1rIM+pJnGXWJcq4P4W4hstxifrv7hkxnnLIto
	XF+W65YkHbroXNQT4gFmnuXVmlZ1hpRUwXKaGlcfdKTEI2S+oRHQZQFHTQo9t9Vgl/8eM0NncOs
	OdHxdP0+lTsj/yrFF3zsEg6M1UWW6KX/rC/K7PAU62XnyZ
X-Google-Smtp-Source: AGHT+IFI7aw5Hflr3Zesdi0nYazb40KN8jZ7mrRBERbvb07PBqlelReQ+seRv6/V7wYnwshvoEme0w==
X-Received: by 2002:a05:6808:144e:b0:450:b14:7a6a with SMTP id 5614622812f47-45a6bef2392mr1217539b6e.60.1767800088459;
        Wed, 07 Jan 2026 07:34:48 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a917:5124:7300:7cef])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a5e183ac3sm2398424b6e.4.2026.01.07.07.34.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 07 Jan 2026 07:34:48 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
From: John Groves <John@Groves.net>
X-Google-Original-From: John Groves <john@groves.net>
To: John Groves <John@Groves.net>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Dan Williams <dan.j.williams@intel.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>
Cc: John Groves <jgroves@micron.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Chen Linxuan <chenlinxuan@uniontech.com>,
	James Morse <james.morse@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Gregory Price <gourry@gourry.net>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	venkataravis@micron.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	John Groves <john@groves.net>
Subject: [PATCH V3 0/4] libfuse: add basic famfs support to libfuse
Date: Wed,  7 Jan 2026 09:34:39 -0600
Message-ID: <20260107153443.64794-1-john@groves.net>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260107153244.64703-1-john@groves.net>
References: <20260107153244.64703-1-john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit


This short series adds adds the necessary support for famfs to libfuse.

This series is also a pull request at [1].

References

[1] - https://github.com/libfuse/libfuse/pull/1414


John Groves (4):
  fuse_kernel.h: bring up to baseline 6.19
  fuse_kernel.h: add famfs DAX fmap protocol definitions
  fuse: add API to set kernel mount options
  fuse: add famfs DAX fmap support

 include/fuse_common.h   |  5 +++
 include/fuse_kernel.h   | 98 ++++++++++++++++++++++++++++++++++++++++-
 include/fuse_lowlevel.h | 47 ++++++++++++++++++++
 lib/fuse_i.h            |  1 +
 lib/fuse_lowlevel.c     | 36 ++++++++++++++-
 lib/fuse_versionscript  |  1 +
 lib/mount.c             |  8 ++++
 7 files changed, 194 insertions(+), 2 deletions(-)


base-commit: 6278995cca991978abd25ebb2c20ebd3fc9e8a13
-- 
2.49.0

