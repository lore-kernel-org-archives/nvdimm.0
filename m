Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52E6313284
	for <nvdimm@lists.linux.dev>; Wed,  5 Nov 2025 12:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762346851; cv=none; b=OUq0I8ZfeSUS8XHJcIqNAmJenv0enXOkpE3iszFvPICOtGKN1a6GDuOmkLh+q36BwtFDcC9agX/JpInTyg69BKlHbsKMztltHWtTQf4SlKxX3UA0MT+8bmiMkWKFsojR5CuPIDsNlOcFx4/j4LpluBYav/WNqllq8d3YgUs29ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762346851; c=relaxed/simple;
	bh=6EDEoQ8G1aeH7k2mK0kTG53ah50zIFSO89NPX7Nmkvo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u5Vj8agp2lneqRexvzt8Qmlxp/NdI46YTudhQ3lLzVs1ydjKlwnEHHSjlz4ds5JdoM+YIOh+TF+5cmIxAGEW72pzkSdgjjHFr+Mx0tuKToOpAM2+i+79LdSoO2qNo1N0CJjPZHLODScUHeY9SBRqqylUyufyRchWRbvcVJLPyPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EK9uV/9u; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EK9uV/9u"
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-433100c59dcso20454315ab.0
        for <nvdimm@lists.linux.dev>; Wed, 05 Nov 2025 04:47:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762346849; x=1762951649; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jK/gceny5PWDz/DbB/PatvWx/loVHzoFjA0SzuhB540=;
        b=EK9uV/9uNN3jxbgkojwS4ZK4nvigA+i3mzphXV8RuNWCii8nXNHqwyNzyBFpUaRiVk
         JPlls1OUl22xl3qTxnoWNNUjhZVXpJ4Szp53iphJ6eVA8TsCGFVXeq1zA0Lc8VUOOX1V
         zqbFF/8coW/zGF95bmDs9vIb9YUqg9Fxs0p5tmOLrMIPrHca3s5c0SGTeSBGdW18l8+a
         olK8mnoZGYlXJGmpKGq5SEy83CTn/rYyibYu/milBOvM1KkWb0Qo9LY4NKf5sSdprS0s
         0pzjvanlVjBAArPGihxDtPhi9Tsn8TkXXk9OEsQlSRlMgAxsBWi6v7BLIQuXaJzywEZI
         fgFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762346849; x=1762951649;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jK/gceny5PWDz/DbB/PatvWx/loVHzoFjA0SzuhB540=;
        b=HD9KxdwtKltMLwHZyJ0+NaUlVOX9Hnvl0GhVcwXIj4S2jAoCKI4T4XjebiQM3+hiW+
         tCEVW2DShtr2AfNyI7EHhy6P90jpuZWIiZxALifrYcIZX/AFyn9rlWFM4dL5JDKrJ952
         aybq+A82QpdZ9Uy+OHccR43rGrfSp8lLjQ5XS4mpFdi8eQtmElNdWXmadwqspyNnGzVP
         j975jNAapXuCLwgnLJrq2TvLTpEU5eeaus8h2dxTCbM1eVsEuFhb/QTB2N9uJ3Z5H3sX
         JaZQn9oDbvvGxsBrdC6YqhqJm+OQOc/fYR1ulBUoNtiR9aoLfBJQpdNm7A2MIEhrahbj
         oH/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXJo8/agAjXWvdploe40QrEnyG7Q9L4/kqnf/f/kmATZgCWc+3+qkcHAlsRRvYaT6nwSeD1lL0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzXSMzrmYR6Ts3bXlK5maByeFGYoFF9EF6BiPKlZAi6/K8cjIlA
	NffHEmyQFK1sUkV4CMXNRuFytkxYpt2l5UsjVUCoaqTHSlB0H+TLJiE3
X-Gm-Gg: ASbGncsUVVqcY/FaBqXl0o7XkSUlIvf1m2WmmlgxVNlNSsaKYj7RUb4yovHJGW0ccYp
	Xwf/e68K+o2iD6Q8jz9not+eM7YC6CTHUdG87LiofjScFwQfCCFTrjbqwZl7E09iqIUitDqdnOQ
	crjtmlWSF5IuwGQ5QRuyVe44l5t6Y2WfX3K/var7ROKeSlvER2eXjnVpTI5cGlMOAA17f7EWjih
	BkO7HKCVjhXLjA5IoIFDXHvBwzJ5WZaZtBjfPkKjKPlMRcD9lQn5ATMTHyNWIVaJD1RMxvvIWu3
	aFdKtTeAjR0BP6xX2E5Arxp91420m6Tr4JyRW0KVy4lyuyEq+A0DNeXfmcqNhj6C2o38fJG7sat
	LuRUAMtnAZ5+DmAGuddc+SPsDWnxgOwnjVzigkm+l57+Teu8r5d8Cv1uqnL7bgByYWXL2I7LMLi
	LXyCJTgV0EZZq/CUvXqHYmvQ==
X-Google-Smtp-Source: AGHT+IEYO5OB88hN6eQ+81LrxblmPXtqVllaL/oYvPXtpbKz7v2GjUAoOuzLaXR4zN+F70sNBnHk1Q==
X-Received: by 2002:a05:6e02:12c5:b0:433:2711:c5cc with SMTP id e9e14a558f8ab-433407d953bmr38615765ab.32.1762346848847;
        Wed, 05 Nov 2025 04:47:28 -0800 (PST)
Received: from archie.me ([210.87.74.117])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-43335a91956sm25775835ab.6.2025.11.05.04.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 04:47:27 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 34F4C420A6A0; Wed, 05 Nov 2025 19:47:23 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH] Documentation: btt: Unwrap bit 31-30 nested table
Date: Wed,  5 Nov 2025 19:47:08 +0700
Message-ID: <20251105124707.44736-2-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1100; i=bagasdotme@gmail.com; h=from:subject; bh=6EDEoQ8G1aeH7k2mK0kTG53ah50zIFSO89NPX7Nmkvo=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDJncbjOS1rX8C5NtP+1iKPE08O1B3+IO8QazyyabDETDT VNk3B93lLIwiHExyIopskxK5Gs6vctI5EL7WkeYOaxMIEMYuDgFYCLGmQz/fbmqW3c0rN3CrZr3 786N+jzWK8md8lbFakq3zDX8JKq9GBn6gypMP+cZrJy/wNT8Wc4f13k3brrduMjYqyDROeWzdTU DAA==
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit

Bit 31-30 usage table is already formatted as reST simple table, but it
is wrapped in literal code block instead. Unwrap it.

Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/driver-api/nvdimm/btt.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/driver-api/nvdimm/btt.rst b/Documentation/driver-api/nvdimm/btt.rst
index 107395c042ae07..2d8269f834bd60 100644
--- a/Documentation/driver-api/nvdimm/btt.rst
+++ b/Documentation/driver-api/nvdimm/btt.rst
@@ -83,7 +83,7 @@ flags, and the remaining form the internal block number.
 ======== =============================================================
 Bit      Description
 ======== =============================================================
-31 - 30	 Error and Zero flags - Used in the following way::
+31 - 30	 Error and Zero flags - Used in the following way:
 
 	   == ==  ====================================================
 	   31 30  Description

base-commit: 27600b51fbc8b9a4eba18c8d88d7edb146605f3f
-- 
An old man doll... just what I always wanted! - Clara

