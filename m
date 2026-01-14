Received: from mail-oi1-f195.google.com (mail-oi1-f195.google.com [209.85.167.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C7B381700
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 21:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768426948; cv=none; b=RdpAUGTDDkXJul+E4U6/iR0zwYV/JP8c1HZBfvx/eWcagI8oBfRhMoKC8cwLm5YGLMZuh964qKI5asf6hDlLCuHTQan3qXLNgxfOwEj+LkJ/JgDsRLKzpI58Z/nP7EJ+6084h+P8IQsV6vSGogtkFG6Nq+bVWTuLqM1/inu3EOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768426948; c=relaxed/simple;
	bh=VL5oOUiKrAPPvKr1vFu621tvVEzPIunWgTzSeWNY/A0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Aj3syZekotgEWU/s/Zg2YIzh1RDN64ijokcrnYOCyRGL+la+Ubz/7bEokm5ij6Kzpx7QCiqcQkZoRz9hw41Gf2RFj+8TIiEPAO9YeCKaH2Q9SqBzwzZIH04GgFyQ6msygyxVublhP2aV7ZHCIjCkUADOumr350+4YMZj3+lOnSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YW8U0nql; arc=none smtp.client-ip=209.85.167.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YW8U0nql"
Received: by mail-oi1-f195.google.com with SMTP id 5614622812f47-45c87d82bd2so160411b6e.1
        for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 13:42:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768426925; x=1769031725; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OAgvwt1OR9TYLgNznZNLzZ51Qby0qHLIemjsJLSQFFs=;
        b=YW8U0nqlGwS4GxDOCTHuLZkGo6IOn3wLbf1TxKYN8tgk2aMaSJspZTZOusHRtgJQ5U
         nUkUe+P2O6Cx1ILQkTbCa1jHGegue6zJp2LnocQPwMn+onoEFfwIjB+Xagohjv7Sa0kS
         kMoatz4vwomGoo2hk77sBvJ5rff2b6H4u/PMgVLi84ofWg90cAhtUIE3F77TtCOH9Ns8
         s/OU+EQyekQCRitu2DzUgJA3QjoOq/J9GgvL9uPQqGG66uW4j8TCORQIjOWc3vFMVRJ4
         7Vhh1f9rz+EBJrx1A7MPjH44jEa4//LBDvIQeappH3/V/dGkJUnXZvrquKdlLan9Cc8m
         mcRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768426925; x=1769031725;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OAgvwt1OR9TYLgNznZNLzZ51Qby0qHLIemjsJLSQFFs=;
        b=RN1O6QFlWi96uwb4UGoU8pmZtu/LVLnb1QAq8oXdyU6JF83kIhtWjje8CMX00PeA3q
         bPg71QfSMynl5EHw/K7h3gZBGSsdQz+Flraswo2LuN2LiJyEQErx0uzU2nsqP86CPysB
         Q6PVdlmNEO7mQYHTwcfQ8dT4mcqP6RMtQJffGKDknCoRcdmHdOzHGaS1CR87d56oWFzf
         GOjWlsRNb24aOs8Zps2VnPnX6E3hZtaJ0amrQuKvefwE9TTMpFJFlREA2Jrtzoe/O3+D
         VmVCOP1xkZjf1JD+bzqunq3prEdjGfhnnEYjWTwYB7NAe/aTIB+qZnRAtYC4o0oYNGMX
         3qYQ==
X-Forwarded-Encrypted: i=1; AJvYcCWt3EQYcCVR2ZTjeVvy6Jz0TB9wH7oKnkTKGqsyuHkofyvKL0B6ktUsYA3ZWLPcDGkr+EbmHZk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+Tcgot51aXLU/m7TLFpGYE3H7VewXAQbUrtBHvx48zpCWwfAq
	qmoaU7biq0w5zYJNYs9NobL/rx4gesUvcCi7/Bn9+MiIY8l6zbsAC6uq
X-Gm-Gg: AY/fxX6m7EVvoSYh1uQf6NG1xCh86O0EU4oZJZFDMcGBBtTWYrswRhbPJf/wltvnqVu
	MGVvbPvyhw/MlMUQtDzlJFiblYVqghiyZeuVWOJBLCdapGdQ7ARLl5RiWV4w7Vp+Sz2tcBUb6Nz
	qwGwF++yOQtUgYH3GO0bWRTKNA3XUvLgLR0Az0Z4bDSn3kcU9kZsan72yfF1x1PbNKEdNaCRckN
	cA5U0y433Y8atZBPlCyNXnaHOVv669UH0eb2vw/3znnIiEZO+SyeApFhvBE63kSmJgero8L/Qhw
	qfCdLPkay4gvN0FTXzxIQyhbOCCOeWtzw9IVCC86aPX2Io9kKvuLYTMH/Xjj/6nGdCwl5f6DLjG
	qEH00q6F6BXCz30BXVVK6kIdLPMYShW1fXtdJsJ/xpYuWBHUIkFNinrpapid2dfWMaShC0dkWvI
	X/gO4wmU4b0ek+UzhDP7lBegDrJ2P2fLjHSf+5jKPo3eC/
X-Received: by 2002:a05:6808:18a8:b0:44f:94ef:baa1 with SMTP id 5614622812f47-45c73d673c1mr1898228b6e.22.1768426924855;
        Wed, 14 Jan 2026 13:42:04 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:4c85:2962:e438:72c4])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ce478ee883sm19819637a34.28.2026.01.14.13.42.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 14 Jan 2026 13:42:04 -0800 (PST)
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
Subject: [PATCH V4 18/19] famfs_fuse: Add famfs fmap metadata documentation
Date: Wed, 14 Jan 2026 15:32:05 -0600
Message-ID: <20260114213209.29453-19-john@groves.net>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: John Groves <John@Groves.net>

This describes the fmap metadata - both simple and interleaved

Signed-off-by: John Groves <john@groves.net>
---
 fs/fuse/famfs_kfmap.h | 73 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/fs/fuse/famfs_kfmap.h b/fs/fuse/famfs_kfmap.h
index 0fff841f5a9e..970ad802b492 100644
--- a/fs/fuse/famfs_kfmap.h
+++ b/fs/fuse/famfs_kfmap.h
@@ -7,6 +7,79 @@
 #ifndef FAMFS_KFMAP_H
 #define FAMFS_KFMAP_H
 
+/* KABI version 43 (aka v2) fmap structures
+ *
+ * The location of the memory backing for a famfs file is described by
+ * the response to the GET_FMAP fuse message (defined in
+ * include/uapi/linux/fuse.h
+ *
+ * There are currently two extent formats: Simple and Interleaved.
+ *
+ * Simple extents are just (devindex, offset, length) tuples, where devindex
+ * references a devdax device that must be retrievable via the GET_DAXDEV
+ * message/response.
+ *
+ * The extent list size must be >= file_size.
+ *
+ * Interleaved extents merit some additional explanation. Interleaved
+ * extents stripe data across a collection of strips. Each strip is a
+ * contiguous allocation from a single devdax device - and is described by
+ * a simple_extent structure.
+ *
+ * Interleaved_extent example:
+ *   ie_nstrips = 4
+ *   ie_chunk_size = 2MiB
+ *   ie_nbytes = 24MiB
+ *
+ * ┌────────────┐────────────┐────────────┐────────────┐
+ * │Chunk = 0   │Chunk = 1   │Chunk = 2   │Chunk = 3   │
+ * │Strip = 0   │Strip = 1   │Strip = 2   │Strip = 3   │
+ * │Stripe = 0  │Stripe = 0  │Stripe = 0  │Stripe = 0  │
+ * │            │            │            │            │
+ * └────────────┘────────────┘────────────┘────────────┘
+ * │Chunk = 4   │Chunk = 5   │Chunk = 6   │Chunk = 7   │
+ * │Strip = 0   │Strip = 1   │Strip = 2   │Strip = 3   │
+ * │Stripe = 1  │Stripe = 1  │Stripe = 1  │Stripe = 1  │
+ * │            │            │            │            │
+ * └────────────┘────────────┘────────────┘────────────┘
+ * │Chunk = 8   │Chunk = 9   │Chunk = 10  │Chunk = 11  │
+ * │Strip = 0   │Strip = 1   │Strip = 2   │Strip = 3   │
+ * │Stripe = 2  │Stripe = 2  │Stripe = 2  │Stripe = 2  │
+ * │            │            │            │            │
+ * └────────────┘────────────┘────────────┘────────────┘
+ *
+ * * Data is laid out across chunks in chunk # order
+ * * Columns are strips
+ * * Strips are contiguous devdax extents, normally each coming from a
+ *   different memory device
+ * * Rows are stripes
+ * * The number of chunks is (int)((file_size + chunk_size - 1) / chunk_size)
+ *   (and obviously the last chunk could be partial)
+ * * The stripe_size = (nstrips * chunk_size)
+ * * chunk_num(offset) = offset / chunk_size    //integer division
+ * * strip_num(offset) = chunk_num(offset) % nchunks
+ * * stripe_num(offset) = offset / stripe_size  //integer division
+ * * ...You get the idea - see the code for more details...
+ *
+ * Some concrete examples from the layout above:
+ * * Offset 0 in the file is offset 0 in chunk 0, which is offset 0 in
+ *   strip 0
+ * * Offset 4MiB in the file is offset 0 in chunk 2, which is offset 0 in
+ *   strip 2
+ * * Offset 15MiB in the file is offset 1MiB in chunk 7, which is offset
+ *   3MiB in strip 3
+ *
+ * Notes about this metadata format:
+ *
+ * * For various reasons, chunk_size must be a multiple of the applicable
+ *   PAGE_SIZE
+ * * Since chunk_size and nstrips are constant within an interleaved_extent,
+ *   resolving a file offset to a strip offset within a single
+ *   interleaved_ext is order 1.
+ * * If nstrips==1, a list of interleaved_ext structures degenerates to a
+ *   regular extent list (albeit with some wasted struct space).
+ */
+
 /*
  * The structures below are the in-memory metadata format for famfs files.
  * Metadata retrieved via the GET_FMAP response is converted to this format
-- 
2.52.0

