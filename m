Received: from mail-oi1-f194.google.com (mail-oi1-f194.google.com [209.85.167.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09259397ABB
	for <nvdimm@lists.linux.dev>; Wed,  7 Jan 2026 15:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767800082; cv=none; b=GXaLi4IUj/7FfGUpL3Z43OmzpBqmQK46hixjzUI9sqRjK29lLhCG6z8n/xht84+BZ/jQsCz0xUxR+P9ffMp+HREizUgzmT3y5ZS4v5qT2Uh3SZgRB3nsdXio7TiB0I9ZAU6f3g8t+v4TYMh1+NvSCGLaFlVIxGnphaAbHa4/7OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767800082; c=relaxed/simple;
	bh=+muXBvOeYTMbD8nIPUObSxhKcu4jsEupVVL6nK1rpsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i6fmZu80R438920xprdWs+A9uZJWQ118P/sto99kn5AAJEKjd+ClIZbXkYFHFdzejPN9aDN0pvF9TLk+0Dt5k8y/iDHlm9eaggHzxrdeMWvFRfd8hTbUKatopd/+fH+uI09P+7DgcBp/ZsFEjJhBzk5OZLHCIj1qvQ9OOh2PDLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JekNm22+; arc=none smtp.client-ip=209.85.167.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JekNm22+"
Received: by mail-oi1-f194.google.com with SMTP id 5614622812f47-4503ee5c160so1388350b6e.1
        for <nvdimm@lists.linux.dev>; Wed, 07 Jan 2026 07:34:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767800080; x=1768404880; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WDzXFW8FM/AL7CQLZ1rgjH5BjM6661IE1WdAgak/okg=;
        b=JekNm22+8+4UIYtIlbcZP+fNaJfwxLc0sANF00br4PMeCUtDguSq+ivFj9Y1eidY6u
         qUpT59JsFNZiMKk1Ov6FcoNpLIyqMnVsDc52r+Izg72qORo8M8jrF1qsfhZkLv6XQWHu
         hCkvKMZ40p3bJJMGvv011zRaaHAXBJujr+za098zTub9R16lLB+T1Kb88wh9XjpUu9lu
         JfvORnJZr+zUJ6wHP0Qj0fOhreIi/j5baZOWeMqBGGPd6viGKxSLdx/x/NtrThuLgTxH
         ElyhusWs/sCbn3d3OomXUUCF7PPW/1tX+26AqmrWp6/7D4f4gsw0Ad8/UeJnbZaMLkTN
         sqjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767800080; x=1768404880;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WDzXFW8FM/AL7CQLZ1rgjH5BjM6661IE1WdAgak/okg=;
        b=bOQqV9Xa9ncl3SehCVFOrRrTcy9KJ0FHcwiglgcNJ2rMo9/U4D/Jvn6Q/TyAu3C9cK
         ru6h56AvBERkDUEcce2/S8y2k5fAEvT1FB62q/xYiRT3rxcEr+LMrDQ+qRGP8pqQmLAZ
         42J3UX7UuyWQUuDSDaaaH79XDFK3+KsqUqGJx6GIiLckjnKgdkYE1MMQjgvInS+lOQDU
         ecUiBVV6zFUHJTAnmylBdAPQc2wa3cPfuIR0JhjAg7pENWAJGaMBh8bNvOX2KQBkR9pv
         fNHPVGshOxuuzyyNiwaI1t3qkXjL56UbfNo1qm/Rc3+iPk+9K0cy5IpRJ1yDXEWniheN
         VQlA==
X-Forwarded-Encrypted: i=1; AJvYcCVO0vfwdmDdwDln1g6IW6IQf6/0D15a/AgY14ZG9tIGNlX9MRAbbU0u6a8kUd4yj7VKJufW4iI=@lists.linux.dev
X-Gm-Message-State: AOJu0YywOJG78iOM+ZMfRRMi2J17+lwlXrO8f+yFuwKl4yA6MdLQNSXj
	/L6J0xvB56F9hLQk05FO9puL1VaK0TIAuW66Vy0YUAxTgQinIAHw2PJo
X-Gm-Gg: AY/fxX5tKk0BMl/ScAlcXOddIyoRIyrQNyH+QkaBsmhoonEfPl54IKamYsO0EgwLVth
	02Q5B7Qwl6MdB8xRlDAfMpVhBa8UmSbeeSf3P5mf081ExKeXRoKEuOhtRou5h4oe6qP8HrO2AG3
	JNcS+ODFSsLUXvOnOkmN5FMQ3nfzROBxl3QmQFYNvGSOUvq8L89HApT8nHXrxFIcfbwm6k5cwz9
	WnHqzHly+uXyjTiGzzYSccCqPeB2id/wI+6MFqAr0L7E3HDk0/PubZJGGZZOsPZrqzBQruWTRy8
	iub07aOwX63/OuErFsinim6q26NBDeH+U5+joJh/PVtPvNkSz86tVKD55s5epc4901jBap8XeUL
	ZO/PGcYSwfcCSMNnxk5mgeYfDzrEeATonoVaI/2sfstYecYmqhCy6uMv8NwZMb+fsbRBJ54mYiw
	2GoDjtCuULtfQ6oS1MvzOUPD6x97u8dP/I2cXQG0JW+Yth
X-Google-Smtp-Source: AGHT+IH4P/04LMtWqv8sSwu50eq+akkq0AyxmvD1PnTkrLfjOQ9ju3pd7rvqUnQ/LnpHTBBsjZ04Pw==
X-Received: by 2002:a05:6808:309a:b0:450:3122:f0a2 with SMTP id 5614622812f47-45a6bccfa88mr1317344b6e.11.1767800079970;
        Wed, 07 Jan 2026 07:34:39 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a917:5124:7300:7cef])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a5e2f1de5sm2398106b6e.22.2026.01.07.07.34.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 07 Jan 2026 07:34:39 -0800 (PST)
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
Subject: [PATCH V3 20/21] famfs_fuse: Add famfs fmap metadata documentation
Date: Wed,  7 Jan 2026 09:33:29 -0600
Message-ID: <20260107153332.64727-21-john@groves.net>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260107153332.64727-1-john@groves.net>
References: <20260107153244.64703-1-john@groves.net>
 <20260107153332.64727-1-john@groves.net>
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
index 6a6420bdff48..ac5971d4c63a 100644
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
2.49.0

