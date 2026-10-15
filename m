Received: from mail-dy2-f6.google.com (mail-dy2-f6.google.com [74.125.229.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C773D171F
	for <nvdimm@lists.linux.dev>; Thu, 15 Oct 2026 14:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792074873; cv=none; b=HnmBlvdgWwRPnZs9cJ2YapQcDqeSxEcg3qwk6O6/P3Jnmfg2gfmGIGl90TBOJru3413We5BA98h5ZoA+U9cOYuVcAwOfbQ8MnsXycRrnbSdkqpMw4hkpVT5c+BXMIQOfeMpI4n295nN8Io19N20R0e8V7eu5oBTzREi+SxJE4jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792074873; c=relaxed/simple;
	bh=CQ4xayDEoFvr1jT9OHWxpjAmKzgZYc3hdWOA8DdGpNs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Ux9XBNcJxfnw0FOx2Xj2s3HLp7sYPI3ZGE9F4fWUzY5T1Ge+RARelaEnr7dfzfoTj+SpsZPajt5RmWdgMepeJZ8NP1ViSDhAC8DFJPsvqYhH8XBWLzfCIXO2JpcOjhRfT9psZy3rnSqkC0nFj1zhrigzHUqcZTIHvik0vQ+uObY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GAtD2Z2O; arc=none smtp.client-ip=74.125.229.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GAtD2Z2O"
Received: by mail-dy2-f6.google.com with SMTP id 5a478bee46e88-35adc681e1aso1630599eec.0
        for <nvdimm@lists.linux.dev>; Thu, 15 Oct 2026 07:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792074871; x=1792679671; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8neBvXrJ3PxtaBrYkVCU0EsbaYcYW7zqj6dnSnPhyTE=;
        b=GAtD2Z2OVjWQNJGjNasUlTIv5Hbph/MvEw0UWU6UJH6CWLzlnmuSWWJ2JvLJabo33N
         M7dVbTqv0xtkqn2TX0JBa+49Cif6vphafdD9X4AyxORnE1nBLzPv/1VoYk6yHSleIcqk
         FZZni/f7KTtOJ4dIRgw+63ATnVvZJa380ZnaXwcm6PZ4siOr/D9Nl+h/djhoikmIzb4C
         J/esGjf1TUhFjNd+qGSJREr0Z5eeNp9aSe7DhbJoXDQKPww2uG4MUP+ID/LGXJE5feiQ
         uUn1kiSmtJP/FkD6rO8FkOkTYdaaVhnFR6AXD5mNdO8QyBrmqkfE+7x7XHUin8X54zQV
         S2mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792074871; x=1792679671;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8neBvXrJ3PxtaBrYkVCU0EsbaYcYW7zqj6dnSnPhyTE=;
        b=wcmyozOcRgB+XKNz7SkXS1FFMDfhqqtmAnZZ1L2iWDsoEtoslLnIFPzUU/zVQDckhS
         xYRwUNnRBqZPel4SKk1tJ6hf+9y9YKmCsyPhWH7C9I2oTTxS5DfTSz6OO84b4b+pYDH8
         3G/C8dDpnhc/a+6+dZrz9REdFTY8UjaJHOi9Ug4jFUWx6p8KGMbw/VginUng6u2yBZov
         yMeM/OzzXjzX+Fdei9KcSr9wN2l+3LQ7KkJtgBOkzSbTuJEZW17AXDYdDU8rtLCLBSUF
         ocNh3A05UCDv5tjMKg8zUIsov4ztA864xML5JVqKWtiZ2CxzP+FbcxvlXMBMzAH/w9c5
         droQ==
X-Forwarded-Encrypted: i=1; AKwUvBxMDQ3sJK8d1zGBYNMBOH9hNrY16Gt1f1AuB0hIq8LCHuA+810Wf5nqYewTiwLCz3FFTr7j/pc=@lists.linux.dev
X-Gm-Message-State: AFq9FYLqSu7/eLUYpUuZ060LC/t1g0o7J4Ps5oXBZeTa8Yk+NbpNHwYL
	QeuA2H2SW5NSSF8YaxXngJSP04Cv7gjRxtuTLkp9ThjUQsrCwOOpoiFJ
X-Gm-Gg: AYBFou3J0+rfktnW9a5XiqGXO6Q+Qeyq9mRq4Pz9EuYz5ji5iDTHQdne3rWrHOmROeH
	MRZq1Rvg2pxTjZietQ24qIyz4Tiju4Tvl4jbKBI9RRT1m7MuIcP/MqDpfYVYreS5d4l30nZ5Ioy
	qW7P+cyrtgHZ7PQTsoiR/fhkFR/FbPMNoi4MO/zAhADrSZZxVW9DsUBt2M+SULeBQVxUQrfYIup
	kFmZx0YyMw8NrkMjWS/N9OtbmTTyldrrfZ+vYKkDRGAO5t6/2ravWKKp0l/MakkDuROTkf1xJpg
	4V5fHfEJFxZ/foOO4G/U9xQfCfrtOINdabKZe7a0dJfI4WyKVyQb6+RE15InJWAF9c+gnCSnVlL
	XYZSsVMEVBC/eDorcIUjVvE2T4sAHJ95NaiEFjLvxPfBrl9xebu60iRIbpwB3DW5LPER13jKe//
	MUkWbNzZH5Ec+WsstrL4mhdXoFWodYUELHAdgiCIAzOF+yb+6AFWoHIvf4f3k9pd0g84CnMaAgK
	apVjcmGxVZHYjFHZa0TFzStKXPxVLrsXsvua000kfxuuigPjbBlGi5Ta52eYzAeSstfXrdkObGb
	Hg3SysJDMtuCdM4JFaIHcHQ/uscLCGjG2w==
X-Received: by 2002:a05:7301:1a05:b0:358:eccb:af7c with SMTP id 5a478bee46e88-358eccbc89dmr21550282eec.33.1792074871413;
        Thu, 15 Oct 2026 07:34:31 -0700 (PDT)
Received: from localhost (ec2-18-163-127-16.ap-east-1.compute.amazonaws.com. [18.163.127.16])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537ca6d202sm61569751eec.13.2026.10.15.07.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 07:34:31 -0700 (PDT)
From: jianyungao89@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Jianyun Gao <jianyungao89@gmail.com>,
	stable@vger.kernel.org,
	Jan Kara <jack@suse.cz>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dan Williams <djbw@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	linux-fsdevel@vger.kernel.org (open list:FILESYSTEMS (VFS and infrastructure)),
	nvdimm@lists.linux.dev (open list:FILESYSTEM DIRECT ACCESS (DAX))
Subject: [PATCH v3] dax: fix wrong error code returned from dax_dedupe_file_range_compare()
Date: Thu, 15 Oct 2026 22:34:25 +0800
Message-Id: <20261015143426.17620-1-jianyungao89@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jianyun Gao <jianyungao89@gmail.com>

When dax_range_compare_iter() returns a negative error code (e.g. -EIO),
dax_dedupe_file_range_compare() incorrectly returns 'ret' which holds the
positive return value from iomap_iter() indicating more iterations remain.
This positive value leaks to the caller, where vfs_dedupe_file_range()
interprets it as success (bytes_deduped = len), causing userspace to
incorrectly believe deduplication completed.

Return 'status' instead to propagate the actual error code.

Fixes: 0e79e3736d54 ("fsdax: dedupe: iter two files at the same time")
Cc: stable@vger.kernel.org
Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
Changes in v3:
- Fix the Fixes tag to point to the commit that actually introduced
  the bug (0e79e3736d54), not the one that renamed the variable
- Add Reviewed-by from Darrick J. Wong

Link: https://lore.kernel.org/lkml/20261012144925.6728-1-jianyungao89@gmail.com/ # v2
 fs/dax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 6ba50142eeb2..1f6a4fbb97bd 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -2261,7 +2261,7 @@ int dax_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 		status = dax_range_compare_iter(&src_iter, &dst_iter,
 				min(src_iter.len, dst_iter.len), same);
 		if (status < 0)
-			return ret;
+			return status;
 		src_iter.status = dst_iter.status = status;
 	}
 	return ret;
-- 
2.34.1

