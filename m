Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD08B7F
	for <nvdimm@lists.linux.dev>; Wed, 16 Nov 2022 07:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668585472; x=1700121472;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=O9Hb/seFZgmAzrbGw37aYXMPN6dUPFoKLlp7bI7fqcs=;
  b=L4l8yn416CkpnEv8Yg5+acZbdktqLBq/S9aOQsDAa9vj2qtTh3bWNi/s
   BBvcBbXj0zCPga9pJeBoVYhZECKFcQWoKtz1iguhM3m70r4fp8qShSB6W
   +sWU9qyDDtdoII5vlUn4D2Ue4JZiMFvg0sn8IrMEuYCWaZozrkkWAnkAO
   jaGy6C7D7OXx1SaYHokNGvKzKwQ7uMViUQQsxcmHSV+kO5nwAc0vo0Bno
   y0z8wDzJxGn3pLTU+1XkZRQT0yHd0wHrQVuDEHrRxSek/cfYuj/Ll1U1p
   RU+RnNBDHPW5cNIo+ONtaYJimPHTwDaHRoca5aJDd7Rz8yr4wNIGI4flx
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="292186379"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="292186379"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 23:57:48 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="702769361"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="702769361"
Received: from ake-mobl.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.209.189.231])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 23:57:48 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-acpi@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	liushixin2@huawei.com,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH 0/2] ACPI: HMAT: fix single-initiator target registrations
Date: Wed, 16 Nov 2022 00:57:34 -0700
Message-Id: <20221116075736.1909690-1-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=533; h=from:subject; bh=O9Hb/seFZgmAzrbGw37aYXMPN6dUPFoKLlp7bI7fqcs=; b=owGbwMvMwCXGf25diOft7jLG02pJDMkl0z+0n5Rd0mUS/a/ilf0+P0HJpMJrP207rmsxaLvuPHGD z+p9RykLgxgXg6yYIsvfPR8Zj8ltz+cJTHCEmcPKBDKEgYtTACZyXJbhv9P3fVOdRRa3cmeFOSg+Su wWzL0vtdZ9IndjUOGh/dY3UxgZ5n16MNvp2M3vFafNj5+K5toReiJau3+yqJ/f7c0BWcVl/AA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Patch 1 is an obvious cleanup found while fixing this problem.

Patch 2 Fixes a bug with initiator registration for single-initiator
systems. More details on this in its commit message.


Vishal Verma (2):
  ACPI: HMAT: remove unnecessary variable initialization
  ACPI: HMAT: Fix initiator registration for single-initiator systems

 drivers/acpi/numa/hmat.c | 33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)


base-commit: 9abf2313adc1ca1b6180c508c25f22f9395cc780
-- 
2.38.1

