Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CEFB2FAC0E
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 23:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768433413; cv=none; b=XxxXLKvjdsNhOFd70ryKUp0fhaOlHuWzyy6DPFmMmSK+mh4ILxHFx4ApWkIoiAFJNJ4ehQpifg8HVg73L0znIaJJ6Nc0s+Hweal/TKKpQiW5aSkT9ORsDvlA6V+sYimnnuXHALXAt1nUX4lW4mTu1ZkhhW6VR9ZGBvImrQhkvEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768433413; c=relaxed/simple;
	bh=zG2TyLnXjDP5W7454KU8fBzg3dWWFM4U6U41q0cfD0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vapkd2zgMNEnHxmoG2MVZq0EzA5+1fecKDwa639WpNcDyrxLYPleLjM8rlXcpi0qjAvUC9ifANfe8inZK7qwyvRthIwFAXdgRD+er+VA+6C1uL1Syhr2RgKNoWMB+jeukr0nc9Fp0bxMX52xjSTUnicrlBXdqA9f2fY+52ptUa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lyuKbmcl; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lyuKbmcl"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ee14ba3d9cso3770371cf.1
        for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 15:30:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768433404; x=1769038204; darn=lists.linux.dev;
        h=content-transfer-encoding:libfuse:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UUX1Xqe9Ih33TiO90xcxWEJ1pXhMadrkogKYy+yJV2U=;
        b=lyuKbmclJ+143YnqR5p1XEbUL/vg+zIhjrw0yuhCxCU4ijoxV8ey+RNA9YBfjG+BRJ
         ToQ0cTD2SyC5naceIqLAbn+RFZ4XjlKxW7Btj4+r9ka+06uMGLCu/30IGVDkxR1B8bxK
         EUmii41jvvNXdXKKCUFUU5BYbuE/mImpz2A64Io5ys4xMEEc1Mp3vLERlQ8Re2tzWzd8
         nDd8KMr4KLzxR4hRW9lPnPx0PQJCWrPULNhBgSq4MOGvB1Fot9U+BGxWTNta4LODE0Wx
         kHnLj+1hVKPaJDXGwf3RqzTVwNNyJ72CxJXF+zfG8qSxqZCK+KJLF1OBQJt8jWCFAx2u
         MnuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768433404; x=1769038204;
        h=content-transfer-encoding:libfuse:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UUX1Xqe9Ih33TiO90xcxWEJ1pXhMadrkogKYy+yJV2U=;
        b=kTp5x6emPBp5xqDkqfHWQS4FYJxy6OGB7M0S3Zj8T9Q82vUUUJk8XpznJaHIznn7aX
         WmCxGsqKzS3ubOfdiKYNMwG/rzGzuO7tIM/ONfbt+TZMRb0Oa7sl/PUNJ244VXbdeTkb
         p+xKyAdNzzusfLYY0ig6TkZI/i8uZldseCuXmARVen0zlf1wwUpNNXdYULnGn8KPOyJJ
         o5XH+higqxqC6OC4NmKRFJzLec/91/I0ikt5rKE+jFeCmXC25UhP26tO2uNwwKRtNYb3
         uivChQtj+tPvqC2iORiv8SEe1U+n7O4O1aKjVys0NnlRI03nYpIAe7AqjvfLqM+HIG5Y
         4lTg==
X-Forwarded-Encrypted: i=1; AJvYcCWJOu/A6t+qWb8B3pOfDC9pjGs9HoSzbTp7IjYDiwtG1psbRfmERndGZRJQ/F0lkevVB6wkB34=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzik14+YRNJu85cHlioBUTdcGONmpsWrl31LWzEuJB5EIuPpYnn
	vaN6xpwqfxm1wpx0OeNe5+mXhDIZEeIFE2qI3YHSnZZGNTt8/1lhsSIYptMBuQ==
X-Gm-Gg: AY/fxX5b2kXk1Ydiwrss1m8LGokkchjVdizKsnfB2qcLMNkPOlDBCmpe3qbgdrUZuDs
	NEs/3tT5NhteEQCEkJm8cxrCErN7bhrxJHcxyJElQlIyFs+QToyIxa29LIalChTP6Vtb7E5ORHR
	pNp0raEjJoeUCTbbBIhi+Sk165aCvbjhpD1Ne3sIfxD/eSfErTBXbAf+0Y+/+a+0MePPCPVNDsk
	zIRlEv2WbiJY85uj63Yu7BKsiB2L3s35KFLcvkSXfEG0gtNZVnKNWV/ftP1+kV6ADjTLlQUkCg9
	P3dtqyYClF2O36Az4eQWP/lAMk4CzKw6BR0x+KMEHs6STGzBe7vJcNm62B5RjGC75HHdJe6U5C3
	PjPcS80bq6zEfB/w0s2q3Y/TxT3gcw9Ab7UMrcSonDLfHK8HMaEJl0wRuf5wCr0wVNbFVsoZcql
	qOO4mWotu28PVrGJr3PmC5ZTusnuSVmuQzelL0fq1bvJzz
X-Received: by 2002:a05:6808:f8a:b0:450:d833:6bb6 with SMTP id 5614622812f47-45c73d65f1amr2396599b6e.30.1768426990473;
        Wed, 14 Jan 2026 13:43:10 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:4c85:2962:e438:72c4])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a5e1b0779sm11316868b6e.7.2026.01.14.13.43.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 14 Jan 2026 13:43:10 -0800 (PST)
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
Subject: [PATCH V4 0/3]
Date: Wed, 14 Jan 2026 15:43:04 -0600
Message-ID: <20260114214307.29893-1-john@groves.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114153133.29420.compound@groves.net>
References: <20260114153133.29420.compound@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
libfuse: add basic famfs support to libfuse
Content-Transfer-Encoding: 8bit

This short series adds adds the necessary support for famfs to libfuse.

This series is also a pull request at [1].

Changes since V3:
- The patch "add API to set kernel mount options" has been dropped. I found
  a way to accomplish the same thing via getxattr.

References

[1] - https://github.com/libfuse/libfuse/pull/1414


John Groves (3):
  fuse_kernel.h: bring up to baseline 6.19
  fuse_kernel.h: add famfs DAX fmap protocol definitions
  fuse: add famfs DAX fmap support

 include/fuse_common.h   |  5 +++
 include/fuse_kernel.h   | 98 ++++++++++++++++++++++++++++++++++++++++-
 include/fuse_lowlevel.h | 37 ++++++++++++++++
 lib/fuse_lowlevel.c     | 31 ++++++++++++-
 patch/maintainers.txt   |  0
 5 files changed, 169 insertions(+), 2 deletions(-)
 create mode 100644 patch/maintainers.txt


base-commit: 6278995cca991978abd25ebb2c20ebd3fc9e8a13
-- 
2.52.0

