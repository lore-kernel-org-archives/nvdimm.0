Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A291A37B3E1
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 21:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768426916; cv=none; b=CjtU5vZaQROAJXbBUJEHhi19axFF/woyqy9+OlYzoVthuWvfX7KW+6KX3HQAIIc2u2hcacAhpFbFCRyY+eqV+fxjJPgDGm9WYQbPHwY27jOULzZ5qG5x3EQEmWGecZwvwDMk8tbCgJi0tEqt0OB03V1xhSGOoGgwbhMSzGokWxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768426916; c=relaxed/simple;
	bh=XuywZGj+XDpfZvHURwVbpU2ahP9/m0Z4xu0nAUB//wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WypHJ2T+hzKGB1daR2F2h+DOno3JbSpoK8nmu5CaiSHn2dvLWxSbv0BylwrNvZHtv7QJ+0Qx4sDxD0DpUxxwsusa+zBYuHxOqSPoQ6LP2I4NO9MpZzmOsI46nLNEoUEtvis8vZqZ7DLBktT8F4aN/9lf1HlJf7P0QMNRvzzVodg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lD4sNKNw; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lD4sNKNw"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7cfd2423793so202224a34.2
        for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 13:41:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768426892; x=1769031692; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ikg86hLweLFlugyhGYJjhkjBVnchP1h60r6PTv+Ts0E=;
        b=lD4sNKNwcwcV7M80goN8Cxi6yXSNBfXUYdbItgKX08k4Ncts0g6XLZL7mi+4Q7cp+C
         icXZWJ4CiYfp51Do0/IpPtXb/wP/jEMvOjBV8QaWnNMwaUgPL4RYfk9wtzwXnZyvKV7F
         YSfbcsVCEi+C55ibXmTHrtQW1vipsBNgEIANSW0GqMwZPrdJoy3Be/NkxK9pQ+HtGSBL
         dhDTelgdnY+HIZ8ymRD0jRU13DCJXxF5ZSBSPX+sg/m6p/NhgyWxAN7Sb9xVSqbO257C
         Va0XUiIQyNscwcToA+1rob/eJt/rY9akSesaRW91c3Na9ST9nevhi/xzPLXk2HxyM23u
         n0Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768426892; x=1769031692;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ikg86hLweLFlugyhGYJjhkjBVnchP1h60r6PTv+Ts0E=;
        b=eYmdWXydYb57T2PD/le+Cp+a8KrHKy7CEEXyLywhJ3U9ptUDyCBSbaV4UfeBwuqLaK
         qKfYw8cccVfVO9LOAZ6dVOZrr/IsINjOVXdh1kr63RZwvqGL66FebbXzjr0KXZGHrdbm
         BYvp0v+GrvvC+ORKz0AREMlzF34wrx9JiUKcjw8rdlyi6r0sLnsKEXIxEKhbj3D3NubB
         3PTInMjGaMCUmo8fqrTvN+RisEcoa7rqGYfLtEA4ycOnk6fWUUYpnIiyClb2j/q+syXp
         PYXM4mawYOVbs9OdZJbURgYQcDp39mgvnC93GrnGCerssTnNqchriI0M7qYaWtjhzCwp
         Nuyw==
X-Forwarded-Encrypted: i=1; AJvYcCUvBz6N7NEGi+9ouGaC92+R/G3YWlXRfhM4aFv0IijAf+ddqk39asm1fYQ0S23fSD6vUNcs0lw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxuqbqEYAvnAq0YMT3oe1LnUKEKmhlsKxHTbgUlKW0e7t0ify9a
	9yAaNoQxKk1DUiq144AyKnAuudboroEinWhZTG3LYPJO+c0nohjNgFj6
X-Gm-Gg: AY/fxX7LBpyAN0bYlUhj+MWBRRPzGsJ8ocwQFdGKHztvlzYHGKDH38GV8lm7u5uOyLc
	8hVYRP9ABDP8GtnMsRuR5kfPg48xCLFsKKozO1AHeBnDlQG9VEfGBzdOEb6SlWssJ7/M7JAiu8L
	VrNgcv1FLlHKOK1bQ+vZ9Ac+H+S6254zaiOT3DYRFfcazNzRkCufjtyVQreXK6tCkowozw/XBri
	rvAgCSnQZTS1cUCLyca2Kj/adjQfkZGvlQgo3aZ6pUuF/RZ+RLGjydTnR0eMJAlsPx8Nq2CCC58
	fcUjj8QHG+gVlfR5cufxr1xOBk4cmrLgeD/VxMeEM/RgO7g13fPqgX8UalPspMFz5lWVS7N9yAj
	OyXR3Oi68muPNsg3j8dYzUW5U4jS1LB12eV/gR9QQkOAX1IASmk+ALzssB4aFD4/8CE9ECu94jd
	B2kBzqzGDu0nXXS6H+h9URKqlNYPFNi8ySrPX5vdlvj9LU
X-Received: by 2002:a9d:3e49:0:b0:7c5:3c7d:7e67 with SMTP id 46e09a7af769-7cfc8b5155fmr2043023a34.29.1768426892219;
        Wed, 14 Jan 2026 13:41:32 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:4c85:2962:e438:72c4])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ce478ede38sm18802373a34.26.2026.01.14.13.41.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 14 Jan 2026 13:41:31 -0800 (PST)
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
Subject: [PATCH V4 17/19] famfs_fuse: Add DAX address_space_operations with noop_dirty_folio
Date: Wed, 14 Jan 2026 15:32:04 -0600
Message-ID: <20260114213209.29453-18-john@groves.net>
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

From: John Groves <John@Groves.net>

Famfs is memory-backed; there is no place to write back to, and no
reason to mark pages dirty at all.

Signed-off-by: John Groves <john@groves.net>
---
 fs/fuse/famfs.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/fuse/famfs.c b/fs/fuse/famfs.c
index ee3526175b6b..f98e358ea489 100644
--- a/fs/fuse/famfs.c
+++ b/fs/fuse/famfs.c
@@ -14,6 +14,7 @@
 #include <linux/mm.h>
 #include <linux/dax.h>
 #include <linux/iomap.h>
+#include <linux/pagemap.h>
 #include <linux/path.h>
 #include <linux/namei.h>
 #include <linux/string.h>
@@ -39,6 +40,15 @@ static const struct dax_holder_operations famfs_fuse_dax_holder_ops = {
 	.notify_failure		= famfs_dax_notify_failure,
 };
 
+/*
+ * DAX address_space_operations for famfs.
+ * famfs doesn't need dirty tracking - writes go directly to
+ * memory with no writeback required.
+ */
+static const struct address_space_operations famfs_dax_aops = {
+	.dirty_folio	= noop_dirty_folio,
+};
+
 /*****************************************************************************/
 
 /*
@@ -625,6 +635,7 @@ famfs_file_init_dax(
 		}
 		i_size_write(inode, meta->file_size);
 		inode->i_flags |= S_DAX;
+		inode->i_data.a_ops = &famfs_dax_aops;
 	}
  unlock_out:
 	inode_unlock(inode);
-- 
2.52.0

