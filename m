Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8410A31
	for <nvdimm@lists.linux.dev>; Mon, 19 Sep 2022 23:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663631230; x=1695167230;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vnODmAgjnYx1nHlyVa13SsuAKaF4YhWKWtpWXZgWLj8=;
  b=blM7oauhyAX78Kc9Gwaln/uqpJY8pT6utN7UaDXhtYc86r+mQiJ5Tvp7
   x2lTOd5AibWmI1Pa7DnnpSfzxIf/e1S+iYMwVLGyPDM1BJzwhGVzG5tap
   pawcmpVE7eJx+zHnwHnC/eanvA7hO5j+EgOXaGQkZLVjwdctubkU8h0QY
   vw3tMDQfQNAnlw0iA9Mu69uFXtN/DbWpgZuJ7PcQAlrgzn5X5K0A+3/nj
   pbo12vty6m1ee4eUNJvzzkn4sBEmb4Grt6i6udKz7o9BwrhJjpdJiahdN
   AJf+qKNrhlmXwjjODR2b+5yJYAeUYCAQkBc+OX3fvIN1z9i/DyNYWTkck
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10475"; a="300928052"
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="300928052"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 16:47:10 -0700
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="618690539"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 16:47:09 -0700
Subject: [PATCH v2 6/9] cxl: add logging functions for monitor
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org
Cc: alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com,
 bwidawsk@kernel.org, dan.j.williams@intel.com, nafonten@amd.com,
 nvdimm@lists.linux.dev
Date: Mon, 19 Sep 2022 16:47:09 -0700
Message-ID: 
 <166363122964.3861186.7714736198829346130.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <166363103019.3861186.3067220004819656109.stgit@djiang5-desk3.ch.intel.com>
References: 
 <166363103019.3861186.3067220004819656109.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/1.4
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Duplicate log functions from ndctl/monitor to use for stdout and file
logging.

Signed-off-by: Dave Jiang <dave.jiang@gmail.com>
---
 cxl/monitor.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/cxl/monitor.c b/cxl/monitor.c
index 759246926e05..c241ed31584f 100644
--- a/cxl/monitor.c
+++ b/cxl/monitor.c
@@ -39,6 +39,31 @@ static struct monitor {
 	bool human;
 } monitor;
 
+static void log_standard(struct log_ctx *ctx, int priority, const char *file,
+		int line, const char *fn, const char *format, va_list args)
+{
+	if (priority == 6)
+		vfprintf(stdout, format, args);
+	else
+		vfprintf(stderr, format, args);
+}
+
+static void log_file(struct log_ctx *ctx, int priority, const char *file,
+		int line, const char *fn, const char *format, va_list args)
+{
+	FILE *f = monitor.log_file;
+
+	if (priority != LOG_NOTICE) {
+		struct timespec ts;
+
+		clock_gettime(CLOCK_REALTIME, &ts);
+		fprintf(f, "[%10ld.%09ld] [%d] ", ts.tv_sec, ts.tv_nsec, getpid());
+	}
+
+	vfprintf(f, format, args);
+	fflush(f);
+}
+
 static int monitor_event(struct cxl_ctx *ctx)
 {
 	int fd, epollfd, rc = 0, timeout = -1;


