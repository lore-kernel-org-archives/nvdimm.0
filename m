Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD47D39447A
	for <nvdimm@lists.linux.dev>; Wed,  7 Jan 2026 15:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767800061; cv=none; b=BENcLF/HSMWXsWoYxZ5a1a9dASdwFVhIedyLTZsTfvYQRcJdG5gAKKhy6/D4RqUQS2q/aYy5pVSxa0sNXjTRO9HP7sSFWYwa+m+ilzyGCKNPXzQ4IQ2bNYqQtFrXfJyx17tyQpuDXdCqUWTmjxZy+iYQG0hbzA7pW02+hf9Si/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767800061; c=relaxed/simple;
	bh=eVZvTKoGzS9QT9AZIVcrZZeY/VZ69Zoen8NpofDAoxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Btdcu3zhSsptCd7AmnkQYgygdM3IauQ5BsDOCLGjwxJIYjjsZ1F8PP3lo8Ishh90XgYBKMpE2iszY4daLfNxopvgrEpljQEbdLXhGQRv83BLYDfHNB3YaVzWZELk2HxvR/L/PTxpYwXfB1lRM6pkJg3qTaNGp9mVcBVO0edHrSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HDja4cRV; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HDja4cRV"
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-44ffed84cccso586869b6e.0
        for <nvdimm@lists.linux.dev>; Wed, 07 Jan 2026 07:34:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767800058; x=1768404858; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ioRMhdbsJjC8v5pL1MPtuv/dIU5BMDQOIZe20AJ80PY=;
        b=HDja4cRVsEFo4J5abWTF5QKSAtsPHKk7xtfvfcoo9e+ANRRG2jndgOkC57Zfop608h
         dJ1U1a9Ceyzk2uvFHIKLf5Wh/RhgACimtHKXuyQA3AasoXDQG5dOtdenisvDyVm3QoH3
         tpufLEHF4VxgLUAGBsM9KMYZogb2QVam50pCKCWDBMlM0NJTYsBFlOjKIxegT3JsSmdz
         NqhoR9li/4wfHMN8Kwmg/70GFQrThrBpdJruTt/m25WxgjuiCpuXcH9AFj/qo6Hk7WpP
         t7ZAhIF9CA1LYfEpu7msBIRMlF2zP2h9JuqJ+YzccJML/GsUypLt6jDkNnqFy2YDoQ6y
         ithg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767800058; x=1768404858;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ioRMhdbsJjC8v5pL1MPtuv/dIU5BMDQOIZe20AJ80PY=;
        b=oqEu9y+5dbloPAgri37NUk6PI8HVUM7vD10kuPAJltYpISSiwfxkVi6Vpz9IVEYrrz
         kO6wYQXaD8NnHtaZEqN5aJ6A/wBRi4+WuxL/9tIx+Tz5/r0Fk3/PxNx67+XDxi92wv9o
         Zv5EDcFKhZhZ644JdAfOl14JIRri+dYifn6L/VPfJZW4pQ3D2+fe2liFky2OPCMhQsY/
         J4m5d4CCcnu4G6qF+V3w7V46nRvexINNwlbMI21FtMz6cwncEIB2WHW4WHCgQJwAQufR
         K2G2KfUh9ZeibDiIvsfVJ0+U9ZgY9GkQJBgGT2ehBtgHAnMWRKaYoYRVe3XlzTarE+rH
         3Rag==
X-Forwarded-Encrypted: i=1; AJvYcCVPajuEvyTgN5RnouGHn2sIfjEDgW//vPkkyeNHWsr62rV7J7M+9bwOugheA7duOi1L+2LHb54=@lists.linux.dev
X-Gm-Message-State: AOJu0YzBPJe9YpVIXqvcs5F4dQ8tbH0SrvHOuOILvYZRFq8Ylh83bClY
	BQiSyviiXM5hbztd1QybfcjsZu8AVheB8J3EL9UtQP2OTw2+J4sitw3z
X-Gm-Gg: AY/fxX5Yca1ifYQSCTa6bInJEP4gx9NPVzHVP390uvDKLfc93E5EUmHV69QWDAEkBbe
	6eddGLFz0dEwHszKwsic/wnGLEhHz9WRTqdx6ICeoBTL5NH+/o3Zl2WGE/D9BI/NrBYofry4j5t
	EzC4UQbXMya9mPsIEfjvKh6A3BbwXpHXqPgxgn6uNFhaJ8LV19aw/wIelIJsFqK4/D5ClGAcFTw
	Rcg1Tc1MKKPfZ0XZHGwRfrE5mOfLUcB3LGiSOjuhfm3E3a7e6yopymla8Ea87T04wQXw8N16tyR
	frCyxzq+8YNooQAdm9ipvy9TBtqslGtUAubWMtAUrYnitIj0ihgDDJ8JLkCgeJiPa10wYA+VJ3U
	g/nT+j/y71xENzpoPfnq8Y/25QCFR90jU4e4lTDWCzXc4ro119ygdnDW9iZukU20R82RQKYZH/v
	VwqDlMP5P/tPAQ6SIQGqfwvesMmjj/siYNv+M2xK7HZGhh
X-Google-Smtp-Source: AGHT+IG/OP1ZeA8RVwGBd2hiwLTF8z2bJWxQ5Kax1EN4BvyeAQ3tR8TZf8cyaewyY/AtJiZ/nDb6hw==
X-Received: by 2002:a05:6808:3442:b0:453:f62:dddc with SMTP id 5614622812f47-45a6bccd815mr1304391b6e.7.1767800058505;
        Wed, 07 Jan 2026 07:34:18 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a917:5124:7300:7cef])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a5e2f1de5sm2398106b6e.22.2026.01.07.07.34.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 07 Jan 2026 07:34:18 -0800 (PST)
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
Subject: [PATCH V3 13/21] famfs_fuse: Famfs mount opt: -o shadow=<shadowpath>
Date: Wed,  7 Jan 2026 09:33:22 -0600
Message-ID: <20260107153332.64727-14-john@groves.net>
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
Content-Transfer-Encoding: 8bit

The shadow path is a (usually in tmpfs) file system area used by the
famfs user space to communicate with the famfs fuse server. There is a
minor dilemma that the user space tools must be able to resolve from a
mount point path to a shadow path. Passing in the 'shadow=<path>'
argument at mount time causes the shadow path to be exposed via
/proc/mounts, Solving this dilemma. The shadow path is not otherwise
used in the kernel.

Signed-off-by: John Groves <john@groves.net>
---
 fs/fuse/fuse_i.h | 25 ++++++++++++++++++++++++-
 fs/fuse/inode.c  | 28 +++++++++++++++++++++++++++-
 2 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index ec2446099010..84d0ee2a501d 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -620,9 +620,11 @@ struct fuse_fs_context {
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
@@ -998,6 +1000,18 @@ struct fuse_conn {
 		/* Request timeout (in jiffies). 0 = no timeout */
 		unsigned int req_timeout;
 	} timeout;
+
+	/*
+	 * This is a workaround until fuse uses iomap for reads.
+	 * For fuseblk servers, this represents the blocksize passed in at
+	 * mount time and for regular fuse servers, this is equivalent to
+	 * inode->i_blkbits.
+	 */
+	u8 blkbits;
+
+#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
+	char *shadow;
+#endif
 };
 
 /*
@@ -1631,4 +1645,13 @@ extern void fuse_sysctl_unregister(void);
 #define fuse_sysctl_unregister()	do { } while (0)
 #endif /* CONFIG_SYSCTL */
 
+/* famfs.c */
+
+static inline void famfs_teardown(struct fuse_conn *fc)
+{
+#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
+	kfree(fc->shadow);
+#endif
+}
+
 #endif /* _FS_FUSE_I_H */
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index acabf92a11f8..2e0844aabbae 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -783,6 +783,9 @@ enum {
 	OPT_ALLOW_OTHER,
 	OPT_MAX_READ,
 	OPT_BLKSIZE,
+#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
+	OPT_SHADOW,
+#endif
 	OPT_ERR
 };
 
@@ -797,6 +800,9 @@ static const struct fs_parameter_spec fuse_fs_parameters[] = {
 	fsparam_u32	("max_read",		OPT_MAX_READ),
 	fsparam_u32	("blksize",		OPT_BLKSIZE),
 	fsparam_string	("subtype",		OPT_SUBTYPE),
+#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
+	fsparam_string("shadow",		OPT_SHADOW),
+#endif
 	{}
 };
 
@@ -892,6 +898,15 @@ static int fuse_parse_param(struct fs_context *fsc, struct fs_parameter *param)
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
@@ -905,6 +920,7 @@ static void fuse_free_fsc(struct fs_context *fsc)
 
 	if (ctx) {
 		kfree(ctx->subtype);
+		kfree(ctx->shadow);
 		kfree(ctx);
 	}
 }
@@ -936,7 +952,10 @@ static int fuse_show_options(struct seq_file *m, struct dentry *root)
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
 
@@ -1041,6 +1060,8 @@ void fuse_conn_put(struct fuse_conn *fc)
 		WARN_ON(atomic_read(&bucket->count) != 1);
 		kfree(bucket);
 	}
+	famfs_teardown(fc);
+
 	if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
 		fuse_backing_files_free(fc);
 	call_rcu(&fc->rcu, delayed_release);
@@ -1916,6 +1937,11 @@ int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx)
 		*ctx->fudptr = fud;
 		wake_up_all(&fuse_dev_waitq);
 	}
+
+#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
+	fc->shadow = kstrdup(ctx->shadow, GFP_KERNEL);
+#endif
+
 	mutex_unlock(&fuse_mutex);
 	return 0;
 
-- 
2.49.0

