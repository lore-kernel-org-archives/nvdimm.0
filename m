Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9B9315D53;
	Thu, 17 Sep 2026 00:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789604616; cv=none; b=X94WkG7DaQwPBQ94XPOka/yM1w75MJIN/ssn1Z0ksTJKJyjAXPVImXn2HQ6mOzNn0wuUSf0zj8EWhEJ7ZoK9Q/CgwPm9JTnAuFC7WoRBwtmK87adze/NGM4p7s19pp3FjfrJN8ACb+CsIrplFyQy1ME9CTJIpQtWKjc+orFnHbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789604616; c=relaxed/simple;
	bh=wIbp6kbY9SXreddpMl+NLOnyv+09ILKJX/PkZ/rOcPs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ML5iWUOehZCTy0vdInSAUCuiVZ/UYeH6qOyJ9GDvU9K/xjHVHY5Hp8QuRxio9jts2/yHzWuXeKKHlVq0h4P1sgZNEbma0J8I43Q8Oe0VxgOdbr340Q1pW17bFFka1P9JsihTWMZPv2ZotX5Ft5hnbuJ2mFWk8Wdc6s6XQV4V8bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n3ZHEYk4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n3ZHEYk4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96CCD1F008A3;
	Thu, 17 Sep 2026 00:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789604613;
	bh=KJ24bnzQJXUUSHZe3TFDjdsZjI+E1/MFPH+Xn3ggaiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n3ZHEYk43S5MUp2KU16Pyz/HfKJ9F/Gp//yizHZVdnMl+YlFi04w8ku1QQ/Fgyu3o
	 hmqLYr3doGQUYx5xqzvECdbwlgoSI5566pSeYopUVF2P6FWHlm0h13Ah0TB4H+jYLj
	 TwEFK2xrvviOcxoEyJJsVKFLyLDM1bjNII+9Z2OwCEK/LsWBMEKIVbykjrBba5xBEA
	 +pFZV38G+KHl0JANlQhilPzaFg5C6z5u07+l4BmCMNvlGk2Y423YlBI58aIb31ueBU
	 Yz8o/39p9Qowg8zgoH6teLcJNGR5gOAPl63DWOQM00zeH6VlMuadBF3hVT18zuQjjf
	 j17ZcvcRZ3AKQ==
From: Kees Cook <kees@kernel.org>
To: Bill Wendling <morbo@google.com>
Cc: Kees Cook <kees@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	nvdimm@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	linux-hardening@vger.kernel.org
Subject: [PATCH 7/7] nvdimm: ndtest: Return the string length from flags_show()
Date: Wed, 16 Sep 2026 17:23:19 -0700
Message-Id: <20260917002333.2306346-7-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260917002312.i.923-kees@kernel.org>
References: <20260917002312.i.923-kees@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1391; i=kees@kernel.org; h=from:subject; bh=wIbp6kbY9SXreddpMl+NLOnyv+09ILKJX/PkZ/rOcPs=; b=owGbwMvMwCVmps19z/KJym7G02pJDFmrjb5VMJSLB3hvKrnam9S29Evh9AabubMDlHyM2bZc8 768yE6ro5SFQYyLQVZMkSXIzj3OxeNte7j7XEWYOaxMIEMYuDgFYCL3ahkZdr+VVd+omGSdleYZ /mJiuNdXliTHHftl9id8ei8x5fcFJUaGw/q/WAxPikidn7b5Ugu//yZ3Q9mvZrauG9afv3Ov2/k KFwA=
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
Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <iweiny@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Guangshuo Li <lgs201920130244@gmail.com>
Cc: <nvdimm@lists.linux.dev>
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

