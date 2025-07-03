Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27762F3622
	for <nvdimm@lists.linux.dev>; Thu,  3 Jul 2025 18:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751568677; cv=none; b=t23PkGuvAmG/UfUWwIKylPmBqT82pn2yC7sadNRsEYMKbGOH2rq9VuVgm+LBo4CL8frjFg/MRVd//M1HmlmqziLYnKb7hCFT9p5+bS6mbm8VRQiayBgW0uLGuvP7yC1DNgjP17gDhXS5AdgjsTETEQ41tnJQks91RAz72lPCZ8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751568677; c=relaxed/simple;
	bh=AwpmHSUwtyys54NEGAXRI09zoURnC8vbuHi9iQ+9sBI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZvlAE8sylwbK+WaU1Jr7/cQNe5ClxK2G6X4fZyPpq9KZjf8MsUuo3tX5lTzjZCxj3DV219yRNnY9O3UsysL1hVDAAdJdXB0uMY9Uz6PPr/lYDfxxluax31HrBJU1+mQ1p+0meJ0JbDBQpOGGvrT5WplTMIn9LohwIwixb14HD+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F0sDvNFv; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F0sDvNFv"
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-2ea6dd628a7so198969fac.1
        for <nvdimm@lists.linux.dev>; Thu, 03 Jul 2025 11:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751568675; x=1752173475; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oDkFGX1XbHNMHX4qdJagUzrPXsT4EJAQRqP6IodfCe4=;
        b=F0sDvNFvZ+xA+7zgVD0M1nnJYJpEy0Se0iM2TJKfjCCQvt4zndn61RkHblpFgQv7y6
         aGRW5vUld55Qlu7bb+dc4MDBFXfYqOCtpz2HElT8mQhNvktBNhoOF8jTqQa6w52f/RMV
         qN9E1dIY5EX/pauXXlf44e/b8/fy3oc0Onouer7sbB036tr4GNJoZBdt/eFf1R+0fUQ3
         fSKLgfBTvbpfG0ml/OX5UgDsQrflOS4a3G76YxsgG4ZWZwBXu2qHDja3ng47FrTSRETS
         fqxUf44JwEXIiRFbHb4VUc+zDyeXgeTrc2TU4Dx3susJaUcmfvFX8BFdWiohIfeQ29HA
         JM2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751568675; x=1752173475;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oDkFGX1XbHNMHX4qdJagUzrPXsT4EJAQRqP6IodfCe4=;
        b=qT/upiQyr8uHx1zkNQtUzaf/Txg/F9/dX8hTM1j+9cqgSI8XO5iAVv109wKcC9BiRn
         A3y67SI87MDwqIAzxDGQGiYWEDUKmQ/07pMtXAxAPe6zVgLEfEfBIJN3BreEYKWKVrfr
         YUMr66F9GJDfooH8tEFRF7jmxiWkU7vvyGjlzwTw2sqU4qr3y5zsELiTn/MJIxPf7Uzf
         521sbDqkqzTjCZ7vB3VJIgndNSxs8SpTX8i7cZHSw9L1OCCOShTU3wSVbBpy3mimRXF2
         NkdYmVQW2QrzEYta4E450Q2qbPt1uUwFBaSHrjN6n0ZBWWlC+zX/MxXdlJP7q/CONQP/
         2aPA==
X-Forwarded-Encrypted: i=1; AJvYcCX21PKBlvhbDVw1pI2P4Ng0a/Jl1AfFYt9aOywHoMHTr/p7KFrnf+nZDyijcudT3Nks/WXgDL0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzLQhEP4Mc9jISyWOAIsvxD2ep8zsTj5lj36gmQk/OOEjfbFPA0
	schHNV354V8CwjcGfLu4E05DF8dcUjFWnfNZrTLKQpl4Ujpz7Z4XAhm6
X-Gm-Gg: ASbGncsIr6stXp4LFiXTDFVn3ac5a+V6bWh8USC0qt0FWmKUI7DOJLbDrWB29eSQj3Q
	EEMSlV4uQouclT2cZY6riYa+ELapxrDlfRxq6d1idDvcZhh1ZdHfXHAIc5o6z2+Hro80VpgKn4f
	2LNXfOXJI9ABy5hLkHRvfsZJl9FQv6xDm5hbPCzrp4X/JOjtgArYEY7cuom/PMiu3nyPcZavm8m
	8cblXLI02IAoYo7x9KCezx3hm8VOPta7muMEQmAw1iGJSylVgAdLA5Wz/5bu86TGAbG+Z7bZFbi
	Q5HY2qzZDSnUTCG8dQf8U1bqLkZavuQJLhlDM9wPmlmbpbHDlEUmzEmNzb4z+vc0BdAEkKKgkfU
	J3AynvuGAYvbbTA==
X-Google-Smtp-Source: AGHT+IGvk7MVTbXEVO8MsBWhLFSbBMBlbcME3R7purdewnEgQEPBsk82mX9lJGQ/44BnQtmyeHJu2w==
X-Received: by 2002:a05:6871:898a:b0:2ea:841f:773c with SMTP id 586e51a60fabf-2f5a8c25e66mr7281432fac.35.1751568674740;
        Thu, 03 Jul 2025 11:51:14 -0700 (PDT)
Received: from localhost.localdomain ([2603:8080:1500:3d89:cd4:2776:8c4a:3597])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-73c9f90d1ccsm68195a34.44.2025.07.03.11.51.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 11:51:14 -0700 (PDT)
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
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
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
Subject: [RFC V2 11/18] famfs_fuse: Basic famfs mount opts
Date: Thu,  3 Jul 2025 13:50:25 -0500
Message-Id: <20250703185032.46568-12-john@groves.net>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250703185032.46568-1-john@groves.net>
References: <20250703185032.46568-1-john@groves.net>
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
 fs/fuse/inode.c  | 28 +++++++++++++++++++++++++++-
 2 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index a592c1002861..f4ee61046578 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -583,9 +583,11 @@ struct fuse_fs_context {
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
@@ -941,6 +943,10 @@ struct fuse_conn {
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
index e48e11c3f9f3..a7e1cf8257b0 100644
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
 
@@ -1017,6 +1036,9 @@ void fuse_conn_put(struct fuse_conn *fc)
 		}
 		if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
 			fuse_backing_files_free(fc);
+#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
+		kfree(fc->shadow);
+#endif
 		call_rcu(&fc->rcu, delayed_release);
 	}
 }
@@ -1834,6 +1856,10 @@ int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx)
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

