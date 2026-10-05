Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15DD84CEE55;
	Mon,  5 Oct 2026 15:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791215842; cv=none; b=o608G2UiZDRYSbV4jculFRNqO/43Npx1t6RJeosZU6bXm2CtpLYA4b1We16qdet5aIkw76GmXsNfJzMdDjJZjL0Rv7SfpmgzqUe0y3XdhlGbI2KlnVX1fcV5U1+6TXMBHK5fQdI8wiKBuj/S8G42IhHy58/ZoCDG/vc4HFtoBFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791215842; c=relaxed/simple;
	bh=83ejdE21ZGKoH4IcbNOtIYCWNlvKIrQjgUzARamzwfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dOSYRqZdg6oJWsmwPfdIM/CiKWk2jXcXOMb3tz8dgIPgQsEoPNViVrK2q27JbBeUiv5i9u17Flbw2KCqASXcxbYr5+uI/zHvTkuozMkLeDMY8F/H0yHF6+OsSi6oxvK93KO17rm3sycc6caiRjhKtr3e3vuD8sNy3ryqOcfZMGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B/jfaiKY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B/jfaiKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 024B21F008A4;
	Mon,  5 Oct 2026 15:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791215839;
	bh=3OTiHc1/0syaVTh9plxPSwZX9JA+w6f18TNYUs4mWiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B/jfaiKY1DaVksZkgxRP+KtV6co/Ste4zyrEZxOM09D8nw6Y1WUggA+HHzHyLLijI
	 h+iUxjh/eEX3rPqeH4Hh7JRFwgF+YkaupsynORwDpANIaPTcZRFn3xq/ZffqFlkPF0
	 ez6ddGkV3Yq5BqNRUqpIAnVBWWf29NKLt/iJI0EVW5MD7vFE5caqLQ5hSudSpMQKX0
	 vH3jA1sTxjFkXGfC2tQwruEMV1EZ47F3C/weCUVYHykrn0gpJXlfjWL0TPcUnrV8dX
	 vFmLtl3pCjYiLUQSXKdxnlZ6utHw7bFHRUGsaPg4qYLJXssSxzpXrxHOI/Fxw3zOpf
	 iSr4oZ4FITEEA==
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
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH v5 11/12] nvdimm: ndtest: Return the string length from flags_show()
Date: Mon,  5 Oct 2026 08:57:01 -0700
Message-ID: <20261005155708.1471260-11-kees@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005155653.late.426-kees@kernel.org>
References: <20261005155653.late.426-kees@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1205; i=kees@kernel.org; h=from:subject; bh=83ejdE21ZGKoH4IcbNOtIYCWNlvKIrQjgUzARamzwfE=; b=owGbwMvMwCVmps19z/KJym7G02pJDFmHT5wVeXHJcdntO9XMGvYpzF/r2O8cPCBXN+9LzCquy qNb9D6s6ShlYRDjYpAVU2QJsnOPc/F42x7uPlcRZg4rE8gQBi5OAZjI59eMDNPeM56e67P6w2qX XWWTJ2Um39uS9cSg3rrP8pag6JNXrzsZGSYlC6iuNvfntZijP8H4gufTzpD0i1FxulcXTrzNzu2 gzQYA
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
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
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
2.55.0

