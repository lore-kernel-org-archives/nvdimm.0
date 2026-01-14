Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63950374162
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 21:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768426671; cv=none; b=pyBh9Oa2K+7yiYpzcj+Cd40S5aHfk6gQNuTh1syiMQXf4F1jPjBLZBjCzvHKWb4KwwuT4Hxv8hH5oJNqarJCqMywnrXLYcOCIFDwdjv1tK46YOjN1i6TnFhY6SrdTeokE4fb+BYaUS+xrcDl979YlH0eHvO/Tzu/VzoWLbpaY8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768426671; c=relaxed/simple;
	bh=qOSHTOI3Xwy3DZlyVIqnpnTOax8Iqhr9i1N4wEWNc+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xnwbx899Ge3UksOxLcOFHjwDxdI2Hnbdr+oKHY4ZSMFhtX32G6zjLxgTZwXKyKdeuvMMuNxMcFsnpqUPL8NLbpxHr6EJa1pN8/clG3ONaPB0eWXdJi+ODTFM824MbpH2L2lZayxbsYkQsovHDReaFFBSpIaeSxqjy5ZKkbrmCrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KmMKNr3v; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KmMKNr3v"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7c76d855ddbso104504a34.3
        for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 13:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768426628; x=1769031428; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cc2/Dnt7ZvDFJtfoDY9fKj1STHSnh2OdvJ7mPvvodA0=;
        b=KmMKNr3vxHQiO7KczcHEgl2Xc702ZgGbfAZlwiKidyaXl9+2bXULeuiYyXs2MuodhR
         dVQ9Az62pVUYuXDj8k8c0S09dm+F0R1KEnvMvUsEj9YhMfiXtXduYnzkDtq8RwkZKZJR
         pjLtQ/4gDIYuDU04VoU1t3J+HogOYU7Blv3CHYuy0fXVReuwAOi6dTQhXB7EvDfnu6Ih
         4nUX+iienb6JuLb4k75VXP4uDOTjXuPXUgnBz+CkEzXHJIDUkylRACb9lAOLPTWWQcml
         6jVYmanBjqFPMoN6lrKxYsTdfY4C7Bq6xb51Nqo+vv7izPrehH4ecEZbdv24ZWK5ccaX
         KeOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768426628; x=1769031428;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cc2/Dnt7ZvDFJtfoDY9fKj1STHSnh2OdvJ7mPvvodA0=;
        b=vNadoakCR1AxgeIGs9OxOrK7mR/t99dalb5d+Mz+SB6LxTIpZTGwbq+MMQK4wCOBDP
         Qs0w/MZc6vQtDjjs2XuaGQmG1YDLBMHpFPmpnN5czz9DlVfxcuLzW72lP5bt/FnjC+/d
         ijpFmfMp27y+EAbpcvOZVpYUTMZFIIF7ecZsaag9wzbCdxhly9uW9VXtP033FSIEakQN
         gsvoOxqKzCDvRAK2j1mCuSLUBTHgRLMl4gpN6tkiGSA9ITIymDmVxGTYKV3cwHlgr30M
         jhBsqY9FKh013lEuulKQ8jk9A+zkMBuZi8walWL0Hc7qKHOWoMk5pOiEBPX2NTkU330y
         sYIQ==
X-Forwarded-Encrypted: i=1; AJvYcCVtNXfM0KKYUH9o7QMRmPXyaeBgy9QuVUKLHVj89lrivbSHkED4xSR0uLc7jDAAQ6gLXew7KxI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx5OLDAsgr1RadiQ3vhgOEM3ceWOEfDwQ6tjaCnSxIQ4RWDduK5
	AIj0CPwQ0fDPPh7gXysnRFw4QA4Yx60Ykv3175I+c8z4Q89OlipLQvEN
X-Gm-Gg: AY/fxX5K72F+hlqQ4KLJoZoG0xOWyBY+QWr870muEj+l3r9DlPuj3W9e1mtlcFJnqlj
	YDFhlh+ViejkxhEaY2swn3dTJqXT5ukg5GHH4o2TwRM4ogp5ma5Xl1VRrk9vUDZMNluz1YjMr23
	1wZ2VkoO/plebfcmMejYbS/S6rsH67lEmeglFR5BMj1hoEjUyC69V2/Wm2wUuQgK3fzZ9moPcfY
	96/1XPtmnHe3Kqu9TMriqcpHqhFy5U8OJNVTVcXlXina1JNSqwusIkFAFDDdWwgaDkmbOfZbC3U
	KF/4Jq5K04EQMrRT6PWg2k5e3HanE5o2kfUeqAEU+u1W5RrDp9c3xG8bCUw4abDmr1o/sl1D0bV
	D3YKb/rNAWQ5vF38DC5+TtJpvzc5Gswp6iVGLkh9B6DWJrl+DDks7NC3H2QpsMLq7F0qCa3vShN
	RfD2K4Duot8InGnaOXxA4c2slHyl2ZO6/atKFkV7TBIJwAmCr1AFAYFhQ=
X-Received: by 2002:a05:6830:8412:b0:7cb:125d:2a43 with SMTP id 46e09a7af769-7cfc8b6a6b0mr1787867a34.28.1768426628343;
        Wed, 14 Jan 2026 13:37:08 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:4c85:2962:e438:72c4])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ce478ee883sm19811078a34.28.2026.01.14.13.37.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 14 Jan 2026 13:37:08 -0800 (PST)
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
Subject: [PATCH V4 09/19] famfs_fuse: magic.h: Add famfs magic numbers
Date: Wed, 14 Jan 2026 15:31:56 -0600
Message-ID: <20260114213209.29453-10-john@groves.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114213209.29453-1-john@groves.net>
References: <20260114153133.29420.compound@groves.net>
 <20260114213209.29453-1-john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Famfs distinguishes between its on-media and in-memory superblocks. This
reserves the numbers, but they are only used by the user space
components of famfs.

Signed-off-by: John Groves <john@groves.net>
---
 include/uapi/linux/magic.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
index 638ca21b7a90..712b097bf2a5 100644
--- a/include/uapi/linux/magic.h
+++ b/include/uapi/linux/magic.h
@@ -38,6 +38,8 @@
 #define OVERLAYFS_SUPER_MAGIC	0x794c7630
 #define FUSE_SUPER_MAGIC	0x65735546
 #define BCACHEFS_SUPER_MAGIC	0xca451a4e
+#define FAMFS_SUPER_MAGIC	0x87b282ff
+#define FAMFS_STATFS_MAGIC      0x87b282fd
 
 #define MINIX_SUPER_MAGIC	0x137F		/* minix v1 fs, 14 char names */
 #define MINIX_SUPER_MAGIC2	0x138F		/* minix v1 fs, 30 char names */
-- 
2.52.0

