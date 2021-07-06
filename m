Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB47972
	for <nvdimm@lists.linux.dev>; Tue,  6 Jul 2021 04:47:11 +0000 (UTC)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GJqK23Qrgz76C7
	for <nvdimm@lists.linux.dev>; Tue,  6 Jul 2021 12:27:18 +0800 (CST)
Received: from dggema765-chm.china.huawei.com (10.1.198.207) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 6 Jul 2021 12:31:38 +0800
Received: from [127.0.0.1] (10.174.177.249) by dggema765-chm.china.huawei.com
 (10.1.198.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 6 Jul
 2021 12:31:38 +0800
To: <vishal.l.verma@intel.com>
CC: <nvdimm@lists.linux.dev>, linfeilong <linfeilong@huawei.com>,
	<lixiaokeng@huawei.com>, <liuzhiqiang26@huawei.com>, Alison Schofield
	<alison.schofield@intel.com>
From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: [ndctl PATCH v2 0/2] fix two issues reported by Coverity
Message-ID: <c3c08075-4815-8e84-2ba6-64644e72abee@huawei.com>
Date: Tue, 6 Jul 2021 12:31:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.249]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggema765-chm.china.huawei.com (10.1.198.207)
X-CFilter-Loop: Reflected


Recently, we use Coverity to analysis the ndctl package, again.
Two issues should be resolved to make Coverity happy.

Zhiqiang Liu (2):
  libndctl: check return value of ndctl_pfn_get_namespace
  namespace: fix potentail fd leak problem in do_xaction_namespace()

 ndctl/namespace.c | 35 +++++++++++++++++++++++------------
 test/libndctl.c   |  4 ++--
 util/json.c       |  2 ++
 3 files changed, 27 insertions(+), 14 deletions(-)

-- 
2.23.0


