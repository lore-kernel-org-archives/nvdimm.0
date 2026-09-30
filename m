Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E278D4D1788;
	Wed, 30 Sep 2026 23:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790812375; cv=none; b=l1IDRL90alPzokG4diX1FRZIuCEZhM0ckmS/h4m9QcfgXxyQRPtE+Wv9UCoD5r96ghbR6B4kVhEVAVTTZZ2xn4ChKUg0kQYEBxqiuV20ZzHdrX4gAIT7xYQ/nVly4Rzrx66bL4lZAtuhBxgIObryH1AtFnbIpgIbEL7bUIVMc6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790812375; c=relaxed/simple;
	bh=2AtxDeGumxoxvmY3xbTN0AxqV9yj2Kg5m9bB3ZVwy3c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h1hRJ6t0mPALt1oTkVkSom+7n+zVoGmuniLXXVvkMrdetEB/wXHMidmvZ5z5wP9TFIJzAqk9gjgl0VmbboKPbq07KHQNZerIqboErLni56BjsYs/azsGuLA8wGvzuCA+26MxZBXaAl8FPbJiQ2oArvdoceL1IYIX0dtXAj2faXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oUlsyo40; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oUlsyo40"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E631F008A2;
	Wed, 30 Sep 2026 23:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790812371;
	bh=gG1wlNEkwzjCuDccxFHfdxljPSEWGUnfDlpru3ASekE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oUlsyo4092+ef0k+W+EK149GNGIaA9duEa6FaHmoSpE5O4ArtyyKJt8dYAhqtclfG
	 7U0LVYd9laCr0WOTnhaZycuAlk5f5/piWQbjaXzQeZ25M9QJojYIwpaVk+825RAgw5
	 CGZUHg0tboENUnLo9eZohwgChOfvgafiC3wayHH5k11wTs0BpZjBKHIgxPBthM7lIl
	 yIq0RWDJtIcEQN4tpoTsZ92RL6pQNbKqLVYCawCUTRJ6TkVb+HFsp9fHhzTJPKm/Xq
	 bbQT/iLzu7/Xjy2DteSjxJQtv9j7ViEQA+iJuGKHldN8M+me0xH6HbaHkvpV+IfPOp
	 8V+Fi3qgPdsew==
From: Kees Cook <kees@kernel.org>
To: Bill Wendling <morbo@google.com>
Cc: Kees Cook <kees@kernel.org>,
	nvdimm@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Ira Weiny <iweiny@kernel.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	nikitash.mariiaw@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH v3 10/11] nvdimm: ndtest: Return the string length from flags_show()
Date: Wed, 30 Sep 2026 16:52:38 -0700
Message-Id: <20260930235247.157921-10-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260930235231.out.387-kees@kernel.org>
References: <20260930235231.out.387-kees@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1145; i=kees@kernel.org; h=from:subject; bh=2AtxDeGumxoxvmY3xbTN0AxqV9yj2Kg5m9bB3ZVwy3c=; b=owGbwMvMwCVmps19z/KJym7G02pJDFl7FxwTmX25ulfl/vcZB6YynW2bmyn+PmUDl2XFr2flH LM8/55f2VHKwiDGxSArpsgSZOce5+Lxtj3cfa4izBxWJpAhDFycAjCRr88ZGVasO+8UUHK59DD3 lEe1/2In7qytkDDcGuQ4+cyvh1mNk8MZGS6v0DisYbDkstRFa7XALaanIuISFsa+VdW2jWXOefL vDBsA
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

flags_show() build their output with a seq_buf and return seq_buf_used(),
which may include the trailing NUL byte when the seq_buf has
overflowed. Use seq_buf_strlen() instead.

The flag names are far shorter than the PAGE_SIZE buffer sysfs
provides, so this cannot overflow today.

Build tested ARCH=x86_64 with GCC 16.2.0, built out of tree with
make M=tools/testing/nvdimm:
tools/testing/nvdimm/test/ndtest.o

Assisted-by: LLM
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Kees Cook <kees@kernel.org>
---
 tools/testing/nvdimm/test/ndtest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
index 2051ad5d4882..f097f2992966 100644
--- a/tools/testing/nvdimm/test/ndtest.c
+++ b/tools/testing/nvdimm/test/ndtest.c
@@ -693,7 +693,7 @@ static ssize_t flags_show(struct device *dev,
 	if (seq_buf_used(&s))
 		seq_buf_printf(&s, "\n");
 
-	return seq_buf_used(&s);
+	return seq_buf_strlen(&s);
 }
 static DEVICE_ATTR_RO(flags);
 
-- 
2.34.1

