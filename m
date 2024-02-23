Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB823142641
	for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 17:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708710171; cv=none; b=J1vkF3EEtnSYUq3Kg0y6/XmpBgYWdQcxbs9QqVOxqhKXnaKdXuiRMTVXSIFdTboQX71lRV9q5kojSNgAgfZX48JcDh37g2jpZegByVTB/k+wm6HTJ1nJu18tWM/0+QijbyWeFi0o/E8T7wF/f2q8i8512+zuaiKvp0cB13d5BMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708710171; c=relaxed/simple;
	bh=r5pTLGO9XcEXrmVzZJZcGWfD/d6LrnLm1UsYwXS5ZFs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=khElskFVvQHem7zguK1wNLjaGKhmtmNuP+QUy9q2CXJ1ThM4sL9u+yCGtzjsPGqw//9r5Q811cz44OdTg/6g2h7X39uSe4zlmOJ1ewcL8EIugC9N3z584j/CF8zhXa2WK4hMCfM8CDfS5EG+9Cv9HWBvJcyGlCUWwUzhkVETEfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nHRfnyYz; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nHRfnyYz"
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-21f2f6a1035so616161fac.2
        for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 09:42:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708710169; x=1709314969; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SDij1l2aMmKfMAAe6zSZuUvXOX3IygMutNr1gCulSkI=;
        b=nHRfnyYzqMTlIy7oaD1zNZgRSXa1aK5lGyow0pFFlaHH87qSJ4UtEzdMTYL+QQTuY9
         DiaxuojEx3hm/YImvNxWbVzBjtMmgsx+7AXmUoZa6acbtoHsLvWMr1uSqqd38PQrBfBB
         fKJgcFHEVB0BJw5ZxUWL6m++FGOV2Ye8UzzVbeJhgFR9nlijhkNRD3Lj2onvrQXlGpeF
         qxybEhiluFatQ+F0P+ugh8rCAVbXQhW4WDdRsvHwzDn5pQ1ZQ7JE9Nt5tRQ+rySaYaJP
         75E1S5/Snng81OtCKB1XQ744dP6sqPzWorYdhCC7752nH3n5zUSo/B6l6OsNyxY16eZB
         zALA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708710169; x=1709314969;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SDij1l2aMmKfMAAe6zSZuUvXOX3IygMutNr1gCulSkI=;
        b=nKNvKDVIl5RCLZfmZ2mb+l0kzivKqJWXJfIXZeBaMa49gHQbIL8ctpEf+A/PL69apI
         gNLzoUJrXb2Z2v40Fs197grDCS9crMrowMP/dTLjeCoKJSLXluSCNeDlROf/XQJZcP5i
         sF9nXDYQaP8zEfoAc9LJgL2T0UaksAt2xBmLw2uCiThg5CHlu/xDw+4VDJ73rBtD9nkr
         Mz8mcJjrEpCSO2GeULl5U2gAueDXxrl2ZgySWM7SnlL1S9TRw3cC9VR5+UTdWa7OgO45
         q4w4WWDrKOyseyeiUk3kjwVqcgl8DeKJfiSXT1xjo4PlISf01TKfhSUQ4Vmy436ORivs
         lV7g==
X-Forwarded-Encrypted: i=1; AJvYcCUcLHmj3Jr2+1WO3xIrW17631T1RS3nKVXxut4uS+/GC7vZepoM9CHMlLpo7W0v92HFKMrbCASWG+r9qOSEAbt3+DREsJAp
X-Gm-Message-State: AOJu0YxTNIv05CMHhW+SMD46cEWi8uC4HJA2RPMjNLIsk4P1R8E8L8Dj
	QgTaPiKkoosoLhqNdN8BgKj7M+WElvoi/sK340BBBO3q2oloVrDd
X-Google-Smtp-Source: AGHT+IE5JaMy3N1Zd8Sic8j2FBFbUWeO4ntBKm5lkkpOUfdTGrk4SxVvNsysFBkwseINoLvi9Xx++Q==
X-Received: by 2002:a05:6871:340c:b0:21f:c8e1:4514 with SMTP id nh12-20020a056871340c00b0021fc8e14514mr93820oac.13.1708710168899;
        Fri, 23 Feb 2024 09:42:48 -0800 (PST)
Received: from localhost.localdomain (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id rb7-20020a056871618700b0021f6a2bd4b9sm1257803oab.3.2024.02.23.09.42.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 23 Feb 2024 09:42:48 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
From: John Groves <John@Groves.net>
X-Google-Original-From: John Groves <john@groves.net>
To: John Groves <jgroves@micron.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: John@Groves.net,
	john@jagalactic.com,
	Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>,
	dave.hansen@linux.intel.com,
	gregory.price@memverge.com,
	John Groves <john@groves.net>
Subject: [RFC PATCH 11/20] famfs: Add fs_context_operations
Date: Fri, 23 Feb 2024 11:41:55 -0600
Message-Id: <a645646f071e7baa30ef37ea46ea1330ac2eb63f.1708709155.git.john@groves.net>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
In-Reply-To: <cover.1708709155.git.john@groves.net>
References: <cover.1708709155.git.john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This commit introduces the famfs fs_context_operations and
famfs_get_inode() which is used by the context operations.

Signed-off-by: John Groves <john@groves.net>
---
 fs/famfs/famfs_inode.c | 178 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 178 insertions(+)

diff --git a/fs/famfs/famfs_inode.c b/fs/famfs/famfs_inode.c
index 82c861998093..f98f82962d7b 100644
--- a/fs/famfs/famfs_inode.c
+++ b/fs/famfs/famfs_inode.c
@@ -41,6 +41,50 @@ static const struct super_operations famfs_ops;
 static const struct inode_operations famfs_file_inode_operations;
 static const struct inode_operations famfs_dir_inode_operations;
 
+static struct inode *famfs_get_inode(
+	struct super_block *sb,
+	const struct inode *dir,
+	umode_t             mode,
+	dev_t               dev)
+{
+	struct inode *inode = new_inode(sb);
+
+	if (inode) {
+		struct timespec64       tv;
+
+		inode->i_ino = get_next_ino();
+		inode_init_owner(&nop_mnt_idmap, inode, dir, mode);
+		inode->i_mapping->a_ops = &ram_aops;
+		mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
+		mapping_set_unevictable(inode->i_mapping);
+		tv = inode_set_ctime_current(inode);
+		inode_set_mtime_to_ts(inode, tv);
+		inode_set_atime_to_ts(inode, tv);
+
+		switch (mode & S_IFMT) {
+		default:
+			init_special_inode(inode, mode, dev);
+			break;
+		case S_IFREG:
+			inode->i_op = &famfs_file_inode_operations;
+			inode->i_fop = &famfs_file_operations;
+			break;
+		case S_IFDIR:
+			inode->i_op = &famfs_dir_inode_operations;
+			inode->i_fop = &simple_dir_operations;
+
+			/* Directory inodes start off with i_nlink == 2 (for "." entry) */
+			inc_nlink(inode);
+			break;
+		case S_IFLNK:
+			inode->i_op = &page_symlink_inode_operations;
+			inode_nohighmem(inode);
+			break;
+		}
+	}
+	return inode;
+}
+
 /**********************************************************************************
  * famfs super_operations
  *
@@ -150,6 +194,140 @@ famfs_open_device(
 	return 0;
 }
 
+/*****************************************************************************************
+ * fs_context_operations
+ */
+static int
+famfs_fill_super(
+	struct super_block *sb,
+	struct fs_context  *fc)
+{
+	struct famfs_fs_info *fsi = sb->s_fs_info;
+	struct inode *inode;
+	int rc = 0;
+
+	sb->s_maxbytes		= MAX_LFS_FILESIZE;
+	sb->s_blocksize		= PAGE_SIZE;
+	sb->s_blocksize_bits	= PAGE_SHIFT;
+	sb->s_magic		= FAMFS_MAGIC;
+	sb->s_op		= &famfs_ops;
+	sb->s_time_gran		= 1;
+
+	rc = famfs_open_device(sb, fc);
+	if (rc)
+		goto out;
+
+	inode = famfs_get_inode(sb, NULL, S_IFDIR | fsi->mount_opts.mode, 0);
+	sb->s_root = d_make_root(inode);
+	if (!sb->s_root)
+		rc = -ENOMEM;
+
+out:
+	return rc;
+}
+
+enum famfs_param {
+	Opt_mode,
+	Opt_dax,
+};
+
+const struct fs_parameter_spec famfs_fs_parameters[] = {
+	fsparam_u32oct("mode",	  Opt_mode),
+	fsparam_string("dax",     Opt_dax),
+	{}
+};
+
+static int famfs_parse_param(
+	struct fs_context   *fc,
+	struct fs_parameter *param)
+{
+	struct famfs_fs_info *fsi = fc->s_fs_info;
+	struct fs_parse_result result;
+	int opt;
+
+	opt = fs_parse(fc, famfs_fs_parameters, param, &result);
+	if (opt == -ENOPARAM) {
+		opt = vfs_parse_fs_param_source(fc, param);
+		if (opt != -ENOPARAM)
+			return opt;
+
+		return 0;
+	}
+	if (opt < 0)
+		return opt;
+
+	switch (opt) {
+	case Opt_mode:
+		fsi->mount_opts.mode = result.uint_32 & S_IALLUGO;
+		break;
+	case Opt_dax:
+		if (strcmp(param->string, "always"))
+			pr_notice("%s: invalid dax mode %s\n",
+				  __func__, param->string);
+		break;
+	}
+
+	return 0;
+}
+
+static DEFINE_MUTEX(famfs_context_mutex);
+static LIST_HEAD(famfs_context_list);
+
+static int famfs_get_tree(struct fs_context *fc)
+{
+	struct famfs_fs_info *fsi_entry;
+	struct famfs_fs_info *fsi = fc->s_fs_info;
+
+	fsi->rootdev = kstrdup(fc->source, GFP_KERNEL);
+	if (!fsi->rootdev)
+		return -ENOMEM;
+
+	/* Fail if famfs is already mounted from the same device */
+	mutex_lock(&famfs_context_mutex);
+	list_for_each_entry(fsi_entry, &famfs_context_list, fsi_list) {
+		if (strcmp(fsi_entry->rootdev, fc->source) == 0) {
+			mutex_unlock(&famfs_context_mutex);
+			pr_err("%s: already mounted from rootdev %s\n", __func__, fc->source);
+			return -EALREADY;
+		}
+	}
+
+	list_add(&fsi->fsi_list, &famfs_context_list);
+	mutex_unlock(&famfs_context_mutex);
+
+	return get_tree_nodev(fc, famfs_fill_super);
+
+}
+
+static void famfs_free_fc(struct fs_context *fc)
+{
+	struct famfs_fs_info *fsi = fc->s_fs_info;
+
+	if (fsi && fsi->rootdev)
+		kfree(fsi->rootdev);
+
+	kfree(fsi);
+}
+
+static const struct fs_context_operations famfs_context_ops = {
+	.free		= famfs_free_fc,
+	.parse_param	= famfs_parse_param,
+	.get_tree	= famfs_get_tree,
+};
+
+static int famfs_init_fs_context(struct fs_context *fc)
+{
+	struct famfs_fs_info *fsi;
+
+	fsi = kzalloc(sizeof(*fsi), GFP_KERNEL);
+	if (!fsi)
+		return -ENOMEM;
+
+	fsi->mount_opts.mode = FAMFS_DEFAULT_MODE;
+	fc->s_fs_info        = fsi;
+	fc->ops              = &famfs_context_ops;
+	return 0;
+}
 
 
 MODULE_LICENSE("GPL");
-- 
2.43.0

