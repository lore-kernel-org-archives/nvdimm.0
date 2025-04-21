Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B841A23A8
	for <nvdimm@lists.linux.dev>; Mon, 21 Apr 2025 01:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745199270; cv=none; b=PtoLjeX9N97ZRyAdx0SCj7gFL/oASl5+Nih7YpxvsUN2514RhWHt2fJWDniklXcpvqm6zk7NZwmLQHnnfkVJxwjjRB4NGvXVP1ZmhI19y9lhdIB+qr6ibentWG30xnxUTf7xIYm3sP0oIUezET2agIKXbpVOKvrvELlEXUs0HTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745199270; c=relaxed/simple;
	bh=hS9bzYfAqAxrTx0CKZe+FDkhAKFDz+WpXq24E9q0oXo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gS8oU6S7wKuH+be42wdTnn+P4hj60Q0MjFRyBm6IAb0Fi2Q9SbKKxWBhNEp80hXZBg1EyKPZ/3iLMV9anXUWfwILmhUy0chbSk4T0VwM3Yhn+Mqu5XgjgyyV9j0HkSyRrYcOEw18fW/YE4H7IVWwX0Z7PhnTdmX5nE0dAUFU+E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eBKbyVaG; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eBKbyVaG"
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-2c6f27599abso924089fac.2
        for <nvdimm@lists.linux.dev>; Sun, 20 Apr 2025 18:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745199267; x=1745804067; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6jlW0o3VSdWrbOaw+r3nQgVEXzp70rzZbAdQEvNAOUs=;
        b=eBKbyVaGepFqSU9MrKD2d1zJubv+87nUhx8JyMKsGoMbsh6ZJ+RHE03XeEnql6hUMH
         3tQ877Jgc6PgjZ69PX7OGdrANf6PtRmwOx4AWXE1Fu+DAO0OM0b3meUHK3me5k4pmEwT
         aREVQT6gOQ8LbsyB/NE+PsagtBdH98QXQsfKkIN3T3V4YHRW5Mk+Svk0pG3GOuK6V03k
         KSl49g/rni5PAs9o4du2thlbkeUHRYDfLqpb3ez3aTVyGPr/v5Le/SVOWaxSkoqRnqEQ
         poI+/v9jUaiQlvPl/6qhJRzyGpLN1KOmujErQ/fsvQxQ93f6uRsHBSxDv7Kj8WF14rLp
         Q/vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745199267; x=1745804067;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6jlW0o3VSdWrbOaw+r3nQgVEXzp70rzZbAdQEvNAOUs=;
        b=gGi3sp5a3DDx84Jn95eOdBECzsWLDg1tsIHYtHgnpQNLwOxk9nBwFTE1wS1ddUXYkD
         Xb2oL01ZKHXw7YWUQ31NbT9EzRLQX3UqkjirlwMOIibRfZ16u0jVvaiHed0YKo2dmwQM
         KNHmR4afUFKPYs2lTBgyj7tW++RKxX04IIJfIsuy4wICzOGMX1YnRkdQs8emjyOAMEdY
         wSFBIHrSGUscpAc0n82AhsCh8jyM/Bhe9VzOTFxEd/lk46qsWFjdRM4ejP53yoA0Qqmt
         wlHHgbQDEdYKa1GmWr8CZQkT6tVi7sWfqWL4Y07YB3i7xlLASvGtJAH2LwyRgru3UQub
         hlHw==
X-Forwarded-Encrypted: i=1; AJvYcCVyLmsBRmOstBShodPgE6+JqeG7WZX3lRDpjfnsGuFoOI1puUul7PjplO12t8pB0qh9Puo2DtI=@lists.linux.dev
X-Gm-Message-State: AOJu0YyZxtE/lfO0szADCPkJ6oOI1nmnF0Ge6oQzTBPU5Jv49pkrCoaE
	/YM5xV+p06a3X6yE+wp7X6Zl+I5lWzbuG/dI6VwWoHjDtLqGvVBR
X-Gm-Gg: ASbGncso4Ug49oZVV/ocyG0UA0MTXsZwtS0Z0qDb85YDAyCtEY0I1CYVGGTrFAcOOf3
	5wxRJnEuNRNt6/d9Zk7nXsz2w0t1bTwSCZxzaA50c7A3Nh4tUditpt3PxgDUM/9UUNc9A0SE4pP
	U3KQYLKrsy+ggk6OszTmJu9dvtYqRef+Z7h08++qAiog6NL2QEjnxO4PscfU2wTUUrdNXoyiTQV
	u2jQM//Iu7JJsuJ7T2YwT8KLCzk+z2ctmSxgj+gZ3tpRmDN4y7eiHzo4HFxdrIm4Cp7U6b/UJoi
	hUEMSagUNyfpraXPS4eJaWhdxE4xC1NljKmcC3jlanAauK8oO1a8bkzVvt4fRViBr9JPNQ==
X-Google-Smtp-Source: AGHT+IF+9XYJIqWLgWlGUpPhWJ2tjvUozsrrXpH8oCW29Y/FQldm3qVZQBAnxt74Itja45OzzhFhaw==
X-Received: by 2002:a05:6871:bd07:b0:2d5:4fd4:a1a9 with SMTP id 586e51a60fabf-2d54fd4b0a3mr3864201fac.6.1745199267484;
        Sun, 20 Apr 2025 18:34:27 -0700 (PDT)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a8f7:1b36:93ce:8dbf])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7300489cd44sm1267588a34.66.2025.04.20.18.34.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 20 Apr 2025 18:34:27 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
From: John Groves <John@Groves.net>
X-Google-Original-From: John Groves <john@groves.net>
To: John Groves <John@Groves.net>,
	Dan Williams <dan.j.williams@intel.com>,
	Miklos Szeredi <miklos@szeredb.hu>,
	Bernd Schubert <bschubert@ddn.com>
Cc: John Groves <jgroves@micron.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Luis Henriques <luis@igalia.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Petr Vorel <pvorel@suse.cz>,
	Brian Foster <bfoster@redhat.com>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	John Groves <john@groves.net>
Subject: [RFC PATCH 11/19] famfs_fuse: Basic famfs mount opts
Date: Sun, 20 Apr 2025 20:33:38 -0500
Message-Id: <20250421013346.32530-12-john@groves.net>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250421013346.32530-1-john@groves.net>
References: <20250421013346.32530-1-john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

* -o shadow=<shadowpath>
* -o daxdev=<daxdev>

Signed-off-by: John Groves <john@groves.net>
---
 fs/fuse/fuse_i.h |  8 +++++++-
 fs/fuse/inode.c  | 25 ++++++++++++++++++++++++-
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index b2c563b1a1c8..931613102d32 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -580,9 +580,11 @@ struct fuse_fs_context {
 	unsigned int blksize;
 	const char *subtype;
 
-	/* DAX device, may be NULL */
+	/* DAX device for virtiofs, may be NULL */
 	struct dax_device *dax_dev;
 
+	const char *shadow; /* famfs - null if not famfs */
+
 	/* fuse_dev pointer to fill in, should contain NULL on entry */
 	void **fudptr;
 };
@@ -938,6 +940,10 @@ struct fuse_conn {
 	/**  uring connection information*/
 	struct fuse_ring *ring;
 #endif
+
+#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
+	char *shadow;
+#endif
 };
 
 /*
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 5c6947b12503..7f4b73e739cb 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -766,6 +766,9 @@ enum {
 	OPT_ALLOW_OTHER,
 	OPT_MAX_READ,
 	OPT_BLKSIZE,
+#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
+	OPT_SHADOW,
+#endif
 	OPT_ERR
 };
 
@@ -780,6 +783,9 @@ static const struct fs_parameter_spec fuse_fs_parameters[] = {
 	fsparam_u32	("max_read",		OPT_MAX_READ),
 	fsparam_u32	("blksize",		OPT_BLKSIZE),
 	fsparam_string	("subtype",		OPT_SUBTYPE),
+#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
+	fsparam_string("shadow",		OPT_SHADOW),
+#endif
 	{}
 };
 
@@ -875,6 +881,15 @@ static int fuse_parse_param(struct fs_context *fsc, struct fs_parameter *param)
 		ctx->blksize = result.uint_32;
 		break;
 
+#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
+	case OPT_SHADOW:
+		if (ctx->shadow)
+			return invalfc(fsc, "Multiple shadows specified");
+		ctx->shadow = param->string;
+		param->string = NULL;
+		break;
+#endif
+
 	default:
 		return -EINVAL;
 	}
@@ -888,6 +903,7 @@ static void fuse_free_fsc(struct fs_context *fsc)
 
 	if (ctx) {
 		kfree(ctx->subtype);
+		kfree(ctx->shadow);
 		kfree(ctx);
 	}
 }
@@ -919,7 +935,10 @@ static int fuse_show_options(struct seq_file *m, struct dentry *root)
 	else if (fc->dax_mode == FUSE_DAX_INODE_USER)
 		seq_puts(m, ",dax=inode");
 #endif
-
+#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
+	if (fc->shadow)
+		seq_printf(m, ",shadow=%s", fc->shadow);
+#endif
 	return 0;
 }
 
@@ -1825,6 +1844,10 @@ int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx)
 	sb->s_root = root_dentry;
 	if (ctx->fudptr)
 		*ctx->fudptr = fud;
+
+#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
+	fc->shadow = kstrdup(ctx->shadow, GFP_KERNEL);
+#endif
 	mutex_unlock(&fuse_mutex);
 	return 0;
 
-- 
2.49.0

