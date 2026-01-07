Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48BA7399A55
	for <nvdimm@lists.linux.dev>; Wed,  7 Jan 2026 15:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767800108; cv=none; b=h78DyHV//bemyTFBQNVtrSAFZHdVPOcSlj0UYPDp13TX+ea8d7jlICLeLeblZY0HqELawIOsboDL+EXB6bGkh2XvkFAsGEgAfMNAH+LTgTx6fO+T/adaysutMsbC3gCF6vYRkmt38/GUJCT+dUcQZYWzMNfoc9W+Lr1wH3qrYFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767800108; c=relaxed/simple;
	bh=T7kVRtDmArs/KXDA6UJCem652WSoCrheiHFH0MGwghY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pArq35ib6AzwU/pOB+LObkCW+Ebrf8mrjErcwcZIxQ5uKe3MXA5gVx9Befc6uiMcj8pZQmNHVd6Sh+pBfzd/rvdHa4IJienELR+z6acsUGPlNYWimnavyonZID9CrWtc/MB8oyBFN5Saw55ZrEqPTvpP9A8GExLO2eV37W/dS1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TlnGxn4V; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TlnGxn4V"
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-4510974a8cdso1184383b6e.0
        for <nvdimm@lists.linux.dev>; Wed, 07 Jan 2026 07:35:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767800103; x=1768404903; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BslOQ1R3lDLc6puAK0BHaW8erjjx+/BdZBfKYLZomH0=;
        b=TlnGxn4VJbfZ46ShXo+tIfE7mr+xE0txDWF1KXjXUH12Zi4mnK0V90Hsai60AkC//V
         a8j/H9lIkv5sv33M/sCP2RPMWNTf3QtumWifZrdwJb+hn3xq1V9CkMDroUdYromPPL0Q
         7Zl6gj/dGWDsY/Sau2DpapiDYn8ivYP8GiX1SaoK1BhlilQzxhMOaKzfSD+d3eD/6ni9
         pBaCqKi1LxM38As+j/QYYN/db+kSU+1vj6Xvz3D2V0l1pknG1r7i2lUzWdnj7LRH78bx
         8EGxJofrBQVXFWMmXdb7UmMBNSGALODX58w6NCM+IRAU776mS8korUsQNMezc4xXLdDa
         e/pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767800103; x=1768404903;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BslOQ1R3lDLc6puAK0BHaW8erjjx+/BdZBfKYLZomH0=;
        b=C/m7QPr09bPS1ZOFlgKcZvTYH4FadrxQ7sgY7StDPOhxZvzxJ7itBdJgclo1v07WqD
         41C0xORxL7/TWpZtdc7E5TKg87mR59dJ2CpRSqH2vt+MN8YUvudbBkp+DW7ZDcrQd2Ly
         1TlZGAn9LNPIOtocVBaGAca51pergzLfamxBdL/An89DHaSUUZl4ehkvSs9Ad+YFVA+H
         Ae9Gb2URKtxwAduvavmie/aVX3VTF6rC+lvKJsAjtEwCiWDQCEo0Y8yHsfV7LkBG+QTI
         mjLoX+Tb9u72Z/7qDRbAOTa+xd4SiY+ro+4e32LVSoQq3VLOziBS7L4ArCppGHFERSMK
         p5fg==
X-Forwarded-Encrypted: i=1; AJvYcCWcBCrOGvQQel/6lpo0j6G6B487deMuPurZSTQSXvupYbE3uRmX6Ly33FLd3kBB0rgSMZUnh4A=@lists.linux.dev
X-Gm-Message-State: AOJu0YyYfxbjHvnVpi39coJS/LGVzonjPVi6DMuxYhIpXvfUeFAP8Zvb
	Xf0WVbmhPZ4sTNa++jQjQPIEM+IWRlBG41/2V6K7h/5MtjAt12pVhn3X
X-Gm-Gg: AY/fxX5gploaj7f2XiXUCfHDbyASV/z826akiuqoij3x8cx0H/r7KQMCTEvAZM8xjRb
	ijM/aOZ4stm1kcb2ReWEltoES2BHgDdZa/ipXRY2OAHRx1uhIdt8EDNmMgdLQIWqtyzFloKYo2v
	mRHZp5znc5ZfSWGVrucDRRlvamQLxg2AnEvzCywaB8rGF3ehIihfwZhhaLU/JpcEab7JYSeI8Nm
	YdPCriZtrnrrCE+7D5/e7LWA+ZaSwBpty9pmI4ZkFz7veR32/uHoIplGzMB8g7U1pKT57s8ah9M
	toWyqCQcHxxLF53ucgL/CF5o0dNXtmtjY4MWIRZedS5IF8cjv6RW6MInrXlppwuHbUsXKQh/UlL
	61qZcbi5CNOnTPztDYm+xte9FteCMkj4359GU7dWdMoJYWchfuXFGJHjBrE0pqViCp1zKfMlfLa
	wc5XNQ9IlPZSDuyYhN8Xj7u/oIyMEkyQUMB+IoixWan7ck
X-Google-Smtp-Source: AGHT+IFJGITn60MlSGetG+LZu+Db9CCtjDGtz1GjRDdVPE59eX1t6Y4D5yt852Xe5lWy1d4GVHK31A==
X-Received: by 2002:a05:6808:300f:b0:44d:badf:f449 with SMTP id 5614622812f47-45a6bd18773mr1110582b6e.1.1767800103393;
        Wed, 07 Jan 2026 07:35:03 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a917:5124:7300:7cef])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a5e183cd4sm2415499b6e.1.2026.01.07.07.35.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 07 Jan 2026 07:35:02 -0800 (PST)
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
Subject: [PATCH 0/2] ndctl: Add daxctl support for the new "famfs" mode of devdax
Date: Wed,  7 Jan 2026 09:34:57 -0600
Message-ID: <20260107153459.64821-1-john@groves.net>
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

