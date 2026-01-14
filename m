Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71812D47F1
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 23:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768434268; cv=none; b=VCMUGYH4DOPrvvCafSNxGPdK0PvI6jQktEI3hFqwBLLCdErcvD4KEyW4SDiTo5psvSzotVc9G+FyokdbmfiQcw5Tnx1QFeY+LLZabVTZ7SdEmycjP2QP6uM0R5i+V+GskcfIF3fBtuu2PdyR3EFxsjAvkfrf1ZRnE5l07xavqUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768434268; c=relaxed/simple;
	bh=EHMwJPD2Vt6csWKDxVM2bpGH+6rPVOBI0T+ZdejS8PM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JUOV1tZ0fm5z1W3R9bWA9NXfH+s53TSTnpFUZkV4MQaxz3k7h6cruCMT485h2GQFilMC46ErWHt5h2bZulnZlheAbf2xwoWocjDWmCadE0UWX7Pr53xdQf2Gbm3ZZf73FmSOsEtGf7+ogV+Amlek7oDzajwuJB+hzXGTmiAGe+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=As9+gRVU; arc=none smtp.client-ip=74.125.82.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="As9+gRVU"
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-2b05fe2bf14so809403eec.1
        for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 15:44:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768434262; x=1769039062; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WIEMUdHe6tYyV62gaPFR8QpHnKQnU3PaCpWSzsgNDe8=;
        b=As9+gRVUXbPH0SAGO9CZ3f/wHFl+EzTaj09wht9vFtJDXyPpxzTZbpCZt51wKSOX3W
         m0HVa3rHtxIqBql70gx9MGQavmSqahaJVipfDsOwwx4lTYPdm/yulGJ5v/GXboWzCESy
         h7M9G2RTvgsyXrNI9x7JUsxX9RwnwpSPI9SqGUyrY0WOBGIW4N9jFmuRI9E94TZLdVxm
         cLUiLrcTmn331ii4nMJi6IhGtZ+dwceqi8jSt+bXrapuviv32WCF7rDRC/miQpfJvdk/
         U37a3RalMjAhQQAKPbMJFzmVAgYa/P49R8RPkCot6tzukmEwUCUxDyuQXtSfUWbSlZY9
         v0/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768434262; x=1769039062;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WIEMUdHe6tYyV62gaPFR8QpHnKQnU3PaCpWSzsgNDe8=;
        b=vM8J1VEbnVlDb2knLKe591MZnmUXf0V3TgXdRUC1ORiU4Lzc/zoTahw1wUshJGcKms
         KRbqc6+yqcukEjsrb55ndbCRlnPHkd3YdVDIOr0KxC35uceaju4rwuM2iRm9iQ4czV6X
         k3fSoXiwpxHLyGBbR4c1RvGr9rq2qAOfMavl11AIKgocaQorcjtyHp0/nwRQsGLfA+x/
         ZLNnqlJq0Sfapas9C3HC6isjC2p314e9zKcBApT3EWC0gGXSVIc7/VFPRJQed8wkcbRe
         gcV8nqI9v9tmo1SdRREv7EH73E5xBEMduedf/4mnceoGcg5ra/rpwAbpXBHyItq8//GP
         PRYg==
X-Forwarded-Encrypted: i=1; AJvYcCVta+KOcK8tXBBuHKMO/M+vG3/5z1WzYm5SpU13PGpC7qufUSamdUDEwooP0HGWpEnfDrDm+mY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxGTgdMsCQRjET5cAmxvz0ZikJcfDUYp+nYzZ0C/u0kPi6lRI9c
	UkLAwt964E2/iILwhnhLO82rN+lm4UnJce8MPptjvhNP3M3X85v1QIKTwJsveQ==
X-Gm-Gg: AY/fxX5IJ8AvMGx5upHuFrLrJ1S1LO3qhv60Nh+cpk/H4N/ZcBJ0zOVQt5StMRaCw5p
	vF3AlhCUMOcFO2emBpk/XwXdVnpQmdqt+iGDGjLMlwPRz9Qb1v/2ymIPkxUpn7D8FkoPiVseVFQ
	TKYjSgDtInr4SVqiJyYpUDCQ2U4B4YgskSAJB3Y4L8W9oR+FFCTPH5KAw7lzNeXXjTuzr8nLYTN
	UKifBuvjDEIuKQCfEL3wHFJ1Pz5qgaBmSbFx+8ALLKE9xvYyHFpdCIkXZhmsIb7D/q10ioMbnuR
	Y4A1ZYOkdC3SD1i3q5om6duns57pesXJUhFJfQEUxR6f8R6mORXXmCmU7gRtOjribKLBoK0yM9e
	8T4pB8MsBp31jk32sX3qT7JndKSsjoqG7nBMulxpmkBEXX/t713YMbGp41IVuUjvbrn19JYcl/E
	saq+de0r8Wl9+fCM33U3CaHj/JLYSR7PEUPWG6lv5FbG/m
X-Received: by 2002:a05:6871:7817:b0:3e0:9188:8f10 with SMTP id 586e51a60fabf-40406c5d030mr2965148fac.0.1768427121522;
        Wed, 14 Jan 2026 13:45:21 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:4c85:2962:e438:72c4])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3ffa4de55ffsm17644773fac.2.2026.01.14.13.45.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 14 Jan 2026 13:45:21 -0800 (PST)
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
	linux-fsdevel@vger.kernel.org
Subject: [PATCH V2 0/2] ndctl: Add daxctl support for the new "famfs" mode of devdax
Date: Wed, 14 Jan 2026 15:45:17 -0600
Message-ID: <20260114214519.29999-1-john@groves.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114153133.29420.compound@groves.net>
References: <20260114153133.29420.compound@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No change since V1 - reposting as v2 to keep this with the related
kernel (dax and fuse) patches and libfuse patches.

This short series adds support and tests to daxctl for famfs[1]. The
famfs kernel patch series, under the same "compound cover" as this
series, adds a new 'fsdev_dax' driver for devdax. When that driver
is bound (instead of device_dax), the device is in 'famfs' mode rather
than 'devdax' mode.

References

[1] - https://famfs.org


John Groves (2):
  daxctl: Add support for famfs mode
  Add test/daxctl-famfs.sh to test famfs mode transitions:

 daxctl/device.c                | 126 ++++++++++++++--
 daxctl/json.c                  |   6 +-
 daxctl/lib/libdaxctl-private.h |   2 +
 daxctl/lib/libdaxctl.c         |  77 ++++++++++
 daxctl/lib/libdaxctl.sym       |   7 +
 daxctl/libdaxctl.h             |   3 +
 test/daxctl-famfs.sh           | 253 +++++++++++++++++++++++++++++++++
 test/meson.build               |   2 +
 8 files changed, 465 insertions(+), 11 deletions(-)
 create mode 100755 test/daxctl-famfs.sh


base-commit: 4f7a1c63b3305c97013d3c46daa6c0f76feff10d
-- 
2.49.0

